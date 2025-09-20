const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

// Configure CORS to allow Flutter web app
app.use(cors({
    origin: true, // Allow all origins during development
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    credentials: true,
    optionsSuccessStatus: 200 // Some legacy browsers choke on 204
}));

app.use(bodyParser.json());

// Import and use routes
const authRoutes = require('./routes/auth.routes');
app.use('/auth', authRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Server is running' });
});

module.exports = app;