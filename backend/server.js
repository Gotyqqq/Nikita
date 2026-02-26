const express = require('express');
const http = require('http');
const cors = require('cors');
const socketIo = require('socket.io');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

// Import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const contactRoutes = require('./routes/contacts');
const chatRoutes = require('./routes/chats');
const messageRoutes = require('./routes/messages');

const app = express();
const server = http.createServer(app);

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CLIENT_URL || 'http://localhost:3000',
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/contacts', contactRoutes);
app.use('/api/v1/chats', chatRoutes);
app.use('/api/v1/messages', messageRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'Internal server error'
    }
  });
});

// Socket.IO setup for real-time communication
const io = socketIo(server, {
  cors: {
    origin: process.env.CLIENT_URL || 'http://localhost:3000',
    methods: ['GET', 'POST']
  }
});

// Store active connections
const activeUsers = new Map(); // userId -> socketId

io.on('connection', (socket) => {
  console.log(`User connected: ${socket.id}`);

  // Handle user connection
  socket.on('user_connected', (userId) => {
    activeUsers.set(userId, socket.id);
    // Update user's online status in database
    // This would require importing user service
  });

  // Handle typing indicator
  socket.on('typing_start', ({ chatId }) => {
    socket.to(chatId).emit('user_typing', { 
      userId: getUserIdFromSocket(socket.id), 
      chatId 
    });
  });

  socket.on('typing_stop', ({ chatId }) => {
    socket.to(chatId).emit('user_stopped_typing', { 
      userId: getUserIdFromSocket(socket.id), 
      chatId 
    });
  });

  // Handle marking chat as read
  socket.on('mark_chat_read', ({ chatId, userId }) => {
    // Update message statuses in DB to 'read'
    // Emit event to update read status for sender
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log(`User disconnected: ${socket.id}`);
    
    // Find and remove user from active users
    for (let [userId, socketId] of activeUsers.entries()) {
      if (socketId === socket.id) {
        activeUsers.delete(userId);
        // Update user's online status in database to offline
        // This would require importing user service
        break;
      }
    }
  });
});

// Helper function to get user ID from socket ID
function getUserIdFromSocket(socketId) {
  for (let [userId, sockId] of activeUsers.entries()) {
    if (sockId === socketId) {
      return userId;
    }
  }
  return null;
}

// Function to emit events to specific user
function emitToUser(userId, event, data) {
  const socketId = activeUsers.get(userId);
  if (socketId) {
    io.to(socketId).emit(event, data);
  }
}

// Function to emit events to chat room
function emitToChatRoom(chatId, event, data) {
  io.to(chatId.toString()).emit(event, data);
}

// Make these functions available globally or export them
global.emitToUser = emitToUser;
global.emitToChatRoom = emitToChatRoom;

const PORT = process.env.PORT || 5000;

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = { app, io };