const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

app.use(cors());
app.use(bodyParser.json());

// User-related routes (register, login, update, delete, etc.)
const userRoutes = require('./routes/auth.routes');
app.use('/api/users', userRoutes);

module.exports = app;