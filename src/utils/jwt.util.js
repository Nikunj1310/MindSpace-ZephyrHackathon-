const jwt = require('jsonwebtoken');
require('dotenv').config();

class JWTUtil {
    static generateToken(payload) {
        try {
            // Generate JWT token with user payload
            const token = jwt.sign(
                payload,
                process.env.JWT_SECRET || 'your-super-secret-key',
                {
                    expiresIn: process.env.JWT_EXPIRES_IN || '7d', // 7 days default
                    issuer: 'MindSpace',
                    audience: 'MindSpace-Users'
                }
            );
            return token;
        } catch (error) {
            throw new Error('Error generating token: ' + error.message);
        }
    }

    static verifyToken(token) {
        try {
            // Verify and decode JWT token
            const decoded = jwt.verify(
                token,
                process.env.JWT_SECRET || 'your-super-secret-key',
                {
                    issuer: 'MindSpace',
                    audience: 'MindSpace-Users'
                }
            );
            return decoded;
        } catch (error) {
            if (error.name === 'TokenExpiredError') {
                throw new Error('Token has expired');
            } else if (error.name === 'JsonWebTokenError') {
                throw new Error('Invalid token');
            } else {
                throw new Error('Token verification failed: ' + error.message);
            }
        }
    }

    static generateRefreshToken(payload) {
        try {
            // Generate longer-lived refresh token
            const refreshToken = jwt.sign(
                { ...payload, type: 'refresh' },
                process.env.JWT_REFRESH_SECRET || 'your-super-secret-refresh-key',
                {
                    expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '30d', // 30 days
                    issuer: 'MindSpace',
                    audience: 'MindSpace-Users'
                }
            );
            return refreshToken;
        } catch (error) {
            throw new Error('Error generating refresh token: ' + error.message);
        }
    }

    static verifyRefreshToken(refreshToken) {
        try {
            const decoded = jwt.verify(
                refreshToken,
                process.env.JWT_REFRESH_SECRET || 'your-super-secret-refresh-key',
                {
                    issuer: 'MindSpace',
                    audience: 'MindSpace-Users'
                }
            );
            
            // Ensure it's a refresh token
            if (decoded.type !== 'refresh') {
                throw new Error('Invalid refresh token');
            }
            
            return decoded;
        } catch (error) {
            if (error.name === 'TokenExpiredError') {
                throw new Error('Refresh token has expired');
            } else if (error.name === 'JsonWebTokenError') {
                throw new Error('Invalid refresh token');
            } else {
                throw new Error('Refresh token verification failed: ' + error.message);
            }
        }
    }

    static extractTokenFromHeader(authHeader) {
        if (!authHeader) {
            throw new Error('Authorization header missing');
        }

        const parts = authHeader.split(' ');
        if (parts.length !== 2 || parts[0] !== 'Bearer') {
            throw new Error('Authorization header format should be: Bearer <token>');
        }

        return parts[1];
    }
}

module.exports = JWTUtil;