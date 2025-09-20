const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const db = require('../config/database.js');

const userSchema = new mongoose.Schema({
    userName: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        minlength: 3,
        maxlength: 20
    },
    fullName: {
        type: String,
        required: true,
        trim: true,
        maxlength: 100
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        trim: true,
        match: [/^\S+@\S+\.\S+$/, 'Please enter a valid email']
    },
    password: {
        type: String,
        required: true,
        minlength: 6
    },
    joinedAt: {
        type: Date,
        default: Date.now,
    },
    lastSeen: {
        type: Date,
        default: Date.now,
    },
    streakCount: {
        type: Number,
        default: 0,
        min: 0
    },
    // Current mood rating from 1-10
    currentMood: {
        type: Number,
        min: 1,
        max: 10,
        default: 5,
    },
    // Emoji representing user's current mood
    emoji: {
        type: String,
        default: "\u{1F610}", // Neutral Face using Unicode escape
    },
    // User role: mentor, admin, or regular user
    role: {
        type: String,
        enum: ['mentor', 'admin', 'user'],
        default: 'user',
    }
}, { timestamps: true });

// Hash password before saving user
userSchema.pre('save', async function (next) {
    if (this.isModified('password') || this.isNew) {
        try {
            const salt = await bcrypt.genSalt(10);
            this.password = await bcrypt.hash(this.password, salt);
            next();
        } catch (err) {
            next(err);
        }
    } else {
        next();
    }
});

// Method to compare password
userSchema.methods.comparePassword = async function(candidatePassword) {
    return bcrypt.compare(candidatePassword, this.password);
};

// Method to check if user is admin
userSchema.methods.isAdmin = function() {
    return this.role === 'admin';
};

// Method to check if user is mentor
userSchema.methods.isMentor = function() {
    return this.role === 'mentor';
};

const User = mongoose.model('User', userSchema);

module.exports = User;