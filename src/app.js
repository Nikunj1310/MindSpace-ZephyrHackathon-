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


// User-related routes (register, login, update, delete, etc.)
const userRoutes = require('./routes/auth.routes');
app.use('/api/users', userRoutes);

module.exports = app;