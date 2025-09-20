const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

// Configure CORS to allow Flutter web app
app.use(cors({
    origin: ['http://localhost:8080', 'http://127.0.0.1:8080'],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
}));

app.use(bodyParser.json());


// User-related routes (register, login, update, delete, etc.)
const userRoutes = require('./routes/auth.routes');
app.use('/api/users', userRoutes);

module.exports = app;