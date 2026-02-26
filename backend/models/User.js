const db = require('../config/db');
const bcrypt = require('bcryptjs');

class User {
  constructor(userData) {
    this.id = userData.id;
    this.username = userData.username;
    this.email = userData.email;
    this.password_hash = userData.password_hash;
    this.phone_number = userData.phone_number;
    this.profile_picture_url = userData.profile_picture_url;
    this.status = userData.status;
    this.is_online = userData.is_online;
    this.last_seen = userData.last_seen;
    this.created_at = userData.created_at;
    this.updated_at = userData.updated_at;
  }

  // Create a new user
  static async create(userData) {
    const { username, email, password, phone_number } = userData;
    
    // Hash the password
    const saltRounds = parseInt(process.env.BCRYPT_ROUNDS) || 12;
    const password_hash = await bcrypt.hash(password, saltRounds);

    const query = `
      INSERT INTO users (username, email, password_hash, phone_number)
      VALUES ($1, $2, $3, $4)
      RETURNING id, username, email, profile_picture_url, created_at
    `;
    
    const values = [username, email, password_hash, phone_number];
    const result = await db.query(query, values);
    
    return result.rows[0];
  }

  // Find user by email
  static async findByEmail(email) {
    const query = 'SELECT * FROM users WHERE email = $1';
    const result = await db.query(query, [email]);
    
    if (result.rows.length > 0) {
      return new User(result.rows[0]);
    }
    
    return null;
  }

  // Find user by ID
  static async findById(id) {
    const query = 'SELECT * FROM users WHERE id = $1';
    const result = await db.query(query, [id]);
    
    if (result.rows.length > 0) {
      return new User(result.rows[0]);
    }
    
    return null;
  }

  // Update user profile
  static async updateById(id, updateData) {
    const allowedFields = ['username', 'email', 'profile_picture_url', 'status'];
    const updates = [];
    const values = [];
    
    let paramIndex = 1;
    for (const field of allowedFields) {
      if (updateData[field] !== undefined) {
        updates.push(`${field} = $${paramIndex}`);
        values.push(updateData[field]);
        paramIndex++;
      }
    }
    
    if (updates.length === 0) {
      throw new Error('No valid fields to update');
    }
    
    // Add updated_at timestamp
    updates.push(`updated_at = CURRENT_TIMESTAMP`);
    
    values.push(id); // Last parameter for WHERE clause
    
    const query = `
      UPDATE users 
      SET ${updates.join(', ')} 
      WHERE id = $${paramIndex}
      RETURNING *
    `;
    
    const result = await db.query(query, values);
    
    if (result.rows.length > 0) {
      return new User(result.rows[0]);
    }
    
    return null;
  }

  // Update online status
  static async updateOnlineStatus(userId, isOnline) {
    const query = `
      UPDATE users 
      SET is_online = $1, last_seen = CASE WHEN $1 = false THEN CURRENT_TIMESTAMP ELSE last_seen END
      WHERE id = $2
      RETURNING id, is_online, last_seen
    `;
    
    const result = await db.query(query, [isOnline, userId]);
    
    return result.rows[0];
  }

  // Compare password
  async comparePassword(candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password_hash);
  }
}

module.exports = User;