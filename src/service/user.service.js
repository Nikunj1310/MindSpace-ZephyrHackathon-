const userModel = require('../model/user.model');
const JWTUtil = require('../utils/jwt.util');
// Assumes that the schema is correctly defined in user.controller.js
// and that mongoose connection is established in database.js
class UserService {
    // Create a new user
    static async createUser(userData) {
        try {
            const user = new userModel(userData);
            return await user.save();
        } catch (error) {
            if (error.name === 'ValidationError') {
                // Handle validation errors
                const errors = Object.values(error.errors).map(err => err.message);
                throw new Error(`Validation failed: ${errors.join(', ')}`);
            }
            throw error; // Re-throw other errors
        }
    }

    // Get user by ID
    static async getUserById(userId) {
        try {
            const user = await userModel.findById(userId).exec();
            if (!user) {
                throw new Error(`User with ID ${userId} not found`);
            }
            return user;
        } catch (error) {
            if (error.name === 'CastError') {
                throw new Error(`Invalid user ID format: ${userId}`);
            }
            throw error; // Re-throw other errors (including our custom "not found" error)
        }
    }

    // Update user by ID
    static async updateUser(userId, updateData) {
        try{
            const user = await this.getUserById(userId);
            const NewUser = await userModel.findByIdAndUpdate(userId, updateData, { new: true }).exec();
            return NewUser;
        }catch(error){
            console.log(`${error.message} for user ID: ${userId}`);
            throw error; // Re-throw other errors (including our custom "not found" error)
        }
    }
    
    // Delete user by ID
    static async deleteUser(userId) {
        try {
            const result = await userModel.findByIdAndDelete(userId).exec();
            if (!result) {
                throw new Error(`User with ID ${userId} not found`);
            }
            return result;
        } catch (error) {
            if (error.name === 'CastError') {
                throw new Error(`Invalid user ID format: ${userId}`);
            }
            throw error; // Re-throw other errors
        }
    }

    static async loginUser(userName, password){
        try{
            const user = await userModel.findOne({userName}).exec();
            if(!user)
            {
                throw new Error("Invalid username or password");
            }

            const isPasswordValid = await user.comparePassword(password);
            if(!isPasswordValid)
            {
                throw new Error("Invalid username or password");
            }

            user.lastSeen = new Date();
            await user.save();

            // Generate JWT tokens
            const tokenPayload = {
                userId: user._id.toString(),
                userName: user.userName,
                email: user.email,
                role: user.role
            };

            const accessToken = JWTUtil.generateToken(tokenPayload);
            const refreshToken = JWTUtil.generateRefreshToken(tokenPayload);

            // Return user data with tokens
            const userObject = user.toObject();
            delete userObject.password; // Remove password field before returning
            
            return {
                user: userObject,
                tokens: {
                    accessToken,
                    refreshToken
                }
            };
        } catch (error) {
            if (error.name === 'CastError') {
                throw new Error('Invalid username format');
            }
            throw error; // Re-throw other errors (including our custom authentication errors)
        }
    }

    static async isUserAdmin(userId)
    {
        try{
            const user = await this.getUserById(userId);
            return user.isAdmin();
        }catch(error){
            throw error;
        }
    }

    static async isUserMentor(userId)
    {
        try{
            const user = await this.getUserById(userId);
            return user.isMentor();
        }catch(error){
            throw error;
        }
    }

    static async refreshToken(refreshToken) {
        try {
            // Verify refresh token
            const decoded = JWTUtil.verifyRefreshToken(refreshToken);
            
            // Get user from database to ensure they still exist
            const user = await this.getUserById(decoded.userId);
            
            // Generate new tokens
            const tokenPayload = {
                userId: user._id.toString(),
                userName: user.userName,
                email: user.email,
                role: user.role
            };

            const newAccessToken = JWTUtil.generateToken(tokenPayload);
            const newRefreshToken = JWTUtil.generateRefreshToken(tokenPayload);

            return {
                accessToken: newAccessToken,
                refreshToken: newRefreshToken
            };
        } catch (error) {
            throw error;
        }
    }

    static async googleLoginOrSignup(googleProfile) {
        const { email, fullName } = googleProfile;
        // Try to find user by email
        let user = await userModel.findOne({ email }).exec();
        if (!user) {
            // Generate random username and password
            const randomSuffix = Math.random().toString(36).substring(2, 8);
            const userName = (fullName ? fullName.split(' ')[0] : 'user') + randomSuffix;
            const password = Math.random().toString(36).slice(-10) + Date.now();
            // Create new user
            user = new userModel({
                userName,
                fullName: fullName || userName,
                email,
                password, // Will be hashed by pre-save hook
                role: 'user',
                currentMood: 5,
                emoji: '\u{1F610}'
            });
            await user.save();
        }
        // Generate JWT tokens
        const tokenPayload = {
            userId: user._id.toString(),
            userName: user.userName,
            email: user.email,
            role: user.role
        };
        const accessToken = JWTUtil.generateToken(tokenPayload);
        const refreshToken = JWTUtil.generateRefreshToken(tokenPayload);
        // Return user data with tokens
        const userObject = user.toObject();
        delete userObject.password;
        return {
            user: userObject,
            tokens: {
                accessToken,
                refreshToken
            }
        };
    }
}


module.exports = UserService;