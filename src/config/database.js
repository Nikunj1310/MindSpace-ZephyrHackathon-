const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async() => {
    try{
        await mongoose.connect(process.env.MONGODB_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        }).then(() => {
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
        console.error('Database connection error:', err);
        process.exit(1);
    }
}

module.exports.connectDB = {
    connectDB,
    mongoose
};