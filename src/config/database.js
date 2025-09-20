const mongoose = require('mongoose');
require('dotenv').config();

// Mock data store for testing without MongoDB
let mockUsers = [
    {
        _id: '507f1f77bcf86cd799439011',
        userName: 'testuser',
        fullName: 'Test User',
        email: 'test@example.com',
        password: '$2b$10$rOq8K8QhE5ZFcnvGzrJ8oeF8r0J0t1N1YYzQXJrBdZfY.qLf9N9z2', // 'password123'
        role: 'user',
        joinedAt: new Date(),
        lastSeen: new Date(),
        streakCount: 0,
        currentMood: 5,
        emoji: "😐"
    }
];

const connectDB = async() => {
    try{
        await mongoose.connect(process.env.MONGODB_URI).then(() => {
            console.log(`Database connected successfully to ${process.env.MONGODB_URI}`);
        });

        // Set up event listeners on the connection
        mongoose.connection.on('error', (err) => {
            console.error('Database connection error:', err);
        });
        
        mongoose.connection.on('disconnected', () => {
            console.log('Database disconnected');
        });
        
    }catch(err){
        console.warn('⚠️  MongoDB not available, using in-memory mock data for testing');
        console.log('📝 To use a real database:');
        console.log('   1. Install MongoDB locally, OR');
        console.log('   2. Use MongoDB Atlas cloud service');
        console.log('   3. Update MONGODB_URI in .env file');
        console.log('');
        console.log('🚀 Server will continue with mock data...');
        
        // Don't exit, continue with mock data
        global.useMockData = true;
        global.mockUsers = mockUsers;
    }
}

module.exports = {
    connectDB,
    mongoose,
    mockUsers: () => global.mockUsers || []
};