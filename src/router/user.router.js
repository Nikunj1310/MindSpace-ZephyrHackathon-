const userController = require('../controller/user.controller');
const express = require('express');
const router = express.Router();
const { validateBody, validateParams } = require('../middleware/validation.middleware');
const { userRegistrationSchema, userLoginSchema, userIdSchema, moodUpdateSchema, passwordChangeSchema } = require('../validation/user.validation');