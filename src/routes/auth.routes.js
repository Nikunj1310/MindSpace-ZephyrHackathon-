const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');
const AuthMiddleware = require('../middleware/auth.middleware');

// Public routes (no authentication required)
router.post('/register', UserController.registerUser);
router.post('/login', UserController.loginUser);
router.post('/refresh-token', UserController.refreshToken);

// Protected routes (authentication required)
router.get('/profile/:userId', 
    AuthMiddleware.verifyToken,
    AuthMiddleware.requireOwnershipOrAdmin,
    UserController.getUserById
);

router.put('/profile/:userId', 
    AuthMiddleware.verifyToken, 
    AuthMiddleware.requireOwnershipOrAdmin, 
    UserController.updateUser
);

router.delete('/profile/:userId', 
    AuthMiddleware.verifyToken, 
    AuthMiddleware.requireOwnershipOrAdmin, 
    UserController.deleteUser
);

// Admin only routes
router.get('/admin/:userId/is-admin', 
    AuthMiddleware.verifyToken, 
    AuthMiddleware.requireAdmin, 
    UserController.checkUserAdmin
);

// Mentor/Admin routes
router.get('/mentor/:userId/is-mentor', 
    AuthMiddleware.verifyToken, 
    AuthMiddleware.requireMentorOrAdmin, 
    UserController.checkUserMentor
);

module.exports = router;