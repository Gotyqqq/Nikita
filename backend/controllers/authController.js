const User = require('../models/User');
const { generateAccessToken, generateRefreshToken } = require('../utils/jwtUtils');
const Joi = require('joi');

// Validation schemas
const registerSchema = Joi.object({
  username: Joi.string().alphanum().min(3).max(30).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  phone_number: Joi.string().pattern(/^[\+]?[1-9][\d]{0,15}$/).optional()
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required()
});

// Register controller
const register = async (req, res) => {
  try {
    // Validate input
    const { error, value } = registerSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'INVALID_INPUT',
          message: error.details[0].message,
          details: {
            field: error.details[0].path[0],
            value: error.details[0].context.value
          }
        }
      });
    }

    const { username, email, password, phone_number } = value;

    // Check if user already exists
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(409).json({
        success: false,
        error: {
          code: 'CONFLICT',
          message: 'User with this email already exists'
        }
      });
    }

    // Create new user
    const newUser = await User.create({
      username,
      email,
      password,
      phone_number
    });

    // Generate tokens
    const accessToken = generateAccessToken({
      userId: newUser.id,
      email: newUser.email
    });
    
    const refreshToken = generateRefreshToken({
      userId: newUser.id,
      email: newUser.email
    });

    // TODO: Store refresh token in database for validation

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        user: {
          id: newUser.id,
          username: newUser.username,
          email: newUser.email,
          profile_picture_url: newUser.profile_picture_url,
          created_at: newUser.created_at
        },
        access_token: accessToken,
        refresh_token: refreshToken
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Internal server error during registration'
      }
    });
  }
};

// Login controller
const login = async (req, res) => {
  try {
    // Validate input
    const { error, value } = loginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'INVALID_INPUT',
          message: error.details[0].message,
          details: {
            field: error.details[0].path[0],
            value: error.details[0].context.value
          }
        }
      });
    }

    const { email, password } = value;

    // Find user by email
    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'Invalid email or password'
        }
      });
    }

    // Compare password
    const isValidPassword = await user.comparePassword(password);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'Invalid email or password'
        }
      });
    }

    // Update user's online status
    await User.updateOnlineStatus(user.id, true);

    // Generate tokens
    const accessToken = generateAccessToken({
      userId: user.id,
      email: user.email
    });
    
    const refreshToken = generateRefreshToken({
      userId: user.id,
      email: user.email
    });

    // TODO: Store refresh token in database for validation

    res.status(200).json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          profile_picture_url: user.profile_picture_url,
          is_online: true,
          last_seen: user.last_seen
        },
        access_token: accessToken,
        refresh_token: refreshToken
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Internal server error during login'
      }
    });
  }
};

module.exports = {
  register,
  login
};