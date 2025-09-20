const userServices = require('../service/user.service.js');
const JWTUtil = require('../utils/jwt.util');
const joi = require('joi');
joi.objectId = require('joi-objectid')(joi);

const userRegistrationSchema = joi.object({
    userName: joi.string().min(3).max(20).trim().required(),
    fullName: joi.string().max(100).trim().required(),
    email: joi.string().email().lowercase().trim().required(),
    password: joi.string().min(6).required(),
    currentMood: joi.number().min(1).max(10).optional().default(5),
    emoji: joi.string().optional().default("\u{1F610}"),
    role: joi.string().valid('mentor', 'admin', 'user').optional().default('user')
});

const userLoginSchema = joi.object({
    userName: joi.string().min(3).max(20).required(),
    password: joi.string().min(6).required()
});

const userIdSchema = joi.object({
    userId: joi.objectId().required()
});

// the normal update settings that user has
// other update things like updating the streak count should be done internally
// other update things like updating the role should be done by admin only
const userUpdateSchema = joi.object({
    userId: joi.objectId().required(),
    fullName: joi.string().max(100).trim().optional(),
    email: joi.string().email().lowercase().trim().optional(),
    currentMood: joi.number().min(1).max(10).optional(),
    emoji: joi.string().optional()
});

// Refresh token schema
const refreshTokenSchema = joi.object({
    refreshToken: joi.string().required()
});

class UserController {
    // Register a new user
    static async registerUser(req, res) {
        try {
            // Validate request body
            const { error, value } = userRegistrationSchema.validate(req.body);
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Validation error',
                    details: error.details.map(detail => detail.message)
                });
            }

            // Create user using service
            const newUser = await userServices.createUser(value);
            
            // Generate JWT tokens for the new user
            const tokenPayload = {
                userId: newUser._id.toString(),
                userName: newUser.userName,
                email: newUser.email,
                role: newUser.role
            };

            const accessToken = JWTUtil.generateToken(tokenPayload);
            const refreshToken = JWTUtil.generateRefreshToken(tokenPayload);
            
            // Remove password from response
            const userResponse = newUser.toObject();
            delete userResponse.password;

            res.status(201).json({
                success: true,
                message: 'User registered successfully',
                data: {
                    user: userResponse,
                    tokens: {
                        accessToken,
                        refreshToken
                    }
                }
            });

        } catch (error) {
            // Handle duplicate key errors (email/username already exists)
            if (error.message.includes('E11000') || error.message.includes('duplicate')) {
                return res.status(409).json({
                    success: false,
                    message: 'User already exists with this email or username'
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Login user
    static async loginUser(req, res) {
        try {
            // Validate request body
            const { error, value } = userLoginSchema.validate(req.body);
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Validation error',
                    details: error.details.map(detail => detail.message)
                });
            }

            // Login user using service (returns user + tokens)
            const result = await userServices.loginUser(value.userName, value.password);

            res.status(200).json({
                success: true,
                message: 'Login successful',
                data: result
            });

        } catch (error) {
            if (error.message.includes('Invalid username or password')) {
                return res.status(401).json({
                    success: false,
                    message: 'Invalid username or password'
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Get user by ID
    static async getUserById(req, res) {
        try {
            // Validate request params
            const { error, value } = userIdSchema.validate({ userId: req.params.userId });
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid user ID format'
                });
            }

            // Get user using service
            const user = await userServices.getUserById(value.userId);
            
            // Remove password from response
            const userResponse = user.toObject();
            delete userResponse.password;

            res.status(200).json({
                success: true,
                message: 'User retrieved successfully',
                data: userResponse
            });

        } catch (error) {
            if (error.message.includes('not found')) {
                return res.status(404).json({
                    success: false,
                    message: error.message
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Update user
    static async updateUser(req, res) {
        try {
            // Combine params and body for validation
            const requestData = {
                userId: req.params.userId,
                ...req.body
            };

            // Validate request data
            const { error, value } = userUpdateSchema.validate(requestData);
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Validation error',
                    details: error.details.map(detail => detail.message)
                });
            }

            // Extract userId and update data
            const { userId, ...updateData } = value;

            // Update user using service
            const updatedUser = await userServices.updateUser(userId, updateData);
            
            // Remove password from response
            const userResponse = updatedUser.toObject();
            delete userResponse.password;

            res.status(200).json({
                success: true,
                message: 'User updated successfully',
                data: userResponse
            });

        } catch (error) {
            if (error.message.includes('not found')) {
                return res.status(404).json({
                    success: false,
                    message: error.message
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Delete user
    static async deleteUser(req, res) {
        try {
            // Validate request params
            const { error, value } = userIdSchema.validate({ userId: req.params.userId });
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid user ID format'
                });
            }

            // Delete user using service
            await userServices.deleteUser(value.userId);

            res.status(200).json({
                success: true,
                message: 'User deleted successfully'
            });

        } catch (error) {
            if (error.message.includes('not found')) {
                return res.status(404).json({
                    success: false,
                    message: error.message
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Check if user is admin
    static async checkUserAdmin(req, res) {
        try {
            // Validate request params
            const { error, value } = userIdSchema.validate({ userId: req.params.userId });
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid user ID format'
                });
            }

            // Check admin status using service
            const isAdmin = await userServices.isUserAdmin(value.userId);

            res.status(200).json({
                success: true,
                message: 'Admin status retrieved successfully',
                data: { isAdmin }
            });

        } catch (error) {
            if (error.message.includes('not found')) {
                return res.status(404).json({
                    success: false,
                    message: error.message
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Check if user is mentor
    static async checkUserMentor(req, res) {
        try {
            // Validate request params
            const { error, value } = userIdSchema.validate({ userId: req.params.userId });
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Invalid user ID format'
                });
            }

            // Check mentor status using service
            const isMentor = await userServices.isUserMentor(value.userId);

            res.status(200).json({
                success: true,
                message: 'Mentor status retrieved successfully',
                data: { isMentor }
            });

        } catch (error) {
            if (error.message.includes('not found')) {
                return res.status(404).json({
                    success: false,
                    message: error.message
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
                error: error.message
            });
        }
    }

    // Refresh JWT token
    static async refreshToken(req, res) {
        try {
            // Validate request body
            const { error, value } = refreshTokenSchema.validate(req.body);
            if (error) {
                return res.status(400).json({
                    success: false,
                    message: 'Validation error',
                    details: error.details.map(detail => detail.message)
                });
            }

            // Refresh tokens using service
            const tokens = await userServices.refreshToken(value.refreshToken);

            res.status(200).json({
                success: true,
                message: 'Tokens refreshed successfully',
                data: tokens
            });

        } catch (error) {
            return res.status(401).json({
                success: false,
                message: 'Token refresh failed',
                error: error.message
            });
        }
    }
}

module.exports = UserController;

