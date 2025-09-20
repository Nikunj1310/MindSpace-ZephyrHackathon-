const JWTUtil = require('../utils/jwt.util');
const UserService = require('../service/user.service');

class AuthMiddleware {
    // Middleware to verify JWT token
    static async verifyToken(req, res, next) {
        try {
            // Extract token from Authorization header
            const authHeader = req.headers.authorization;
            const token = JWTUtil.extractTokenFromHeader(authHeader);

            // Verify token
            const decoded = JWTUtil.verifyToken(token);

            // Check if user still exists (optional but recommended)
            const user = await UserService.getUserById(decoded.userId);
            if (!user) {
                return res.status(401).json({
                    success: false,
                    message: 'User no longer exists'
                });
            }

            // Add user info to request object
            req.user = {
                userId: decoded.userId,
                userName: decoded.userName,
                role: decoded.role,
                email: decoded.email
            };

            next();
        } catch (error) {
            return res.status(401).json({
                success: false,
                message: 'Authentication failed',
                error: error.message
            });
        }
    }

    // Middleware to check if user is admin
    static async requireAdmin(req, res, next) {
        try {
            // First verify token (if not already done)
            if (!req.user) {
                await AuthMiddleware.verifyToken(req, res, () => {});
            }

            if (req.user.role !== 'admin') {
                return res.status(403).json({
                    success: false,
                    message: 'Admin access required'
                });
            }

            next();
        } catch (error) {
            return res.status(403).json({
                success: false,
                message: 'Authorization failed',
                error: error.message
            });
        }
    }

    // Middleware to check if user is mentor or admin
    static async requireMentorOrAdmin(req, res, next) {
        try {
            // First verify token (if not already done)
            if (!req.user) {
                await AuthMiddleware.verifyToken(req, res, () => {});
            }

            if (req.user.role !== 'mentor' && req.user.role !== 'admin') {
                return res.status(403).json({
                    success: false,
                    message: 'Mentor or Admin access required'
                });
            }

            next();
        } catch (error) {
            return res.status(403).json({
                success: false,
                message: 'Authorization failed',
                error: error.message
            });
        }
    }

    // Middleware to check if user owns the resource or is admin
    static async requireOwnershipOrAdmin(req, res, next) {
        try {
            // First verify token (if not already done)
            if (!req.user) {
                await AuthMiddleware.verifyToken(req, res, () => {});
            }

            const requestedUserId = req.params.userId;
            
            // Allow if user is admin or accessing their own resource
            if (req.user.role === 'admin' || req.user.userId === requestedUserId) {
                next();
            } else {
                return res.status(403).json({
                    success: false,
                    message: 'Access denied. You can only access your own resources.'
                });
            }
        } catch (error) {
            return res.status(403).json({
                success: false,
                message: 'Authorization failed',
                error: error.message
            });
        }
    }
}

module.exports = AuthMiddleware;