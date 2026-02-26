# Database Schema for Nikita App

## Tables Design

### 1. Users Table
```sql
users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20) UNIQUE,
  profile_picture_url TEXT,
  status VARCHAR(255),
  is_online BOOLEAN DEFAULT FALSE,
  last_seen TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Contacts Table
```sql
contacts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  contact_user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  nickname VARCHAR(100),
  is_blocked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, contact_user_id)
);
```

### 3. Chats Table
```sql
chats (
  id SERIAL PRIMARY KEY,
  type VARCHAR(20) NOT NULL CHECK (type IN ('private', 'group')), -- private or group
  name VARCHAR(100), -- for group chats
  description TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4. Chat Members Table
```sql
chat_members (
  id SERIAL PRIMARY KEY,
  chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) DEFAULT 'member' CHECK (role IN ('admin', 'member')),
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(chat_id, user_id)
);
```

### 5. Messages Table
```sql
messages (
  id SERIAL PRIMARY KEY,
  chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
  sender_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  message_type VARCHAR(20) NOT NULL CHECK (message_type IN ('text', 'image', 'video', 'file', 'audio')),
  content TEXT, -- for text messages
  media_url TEXT, -- for media messages
  media_thumbnail_url TEXT, -- for media previews
  replied_to_message_id INTEGER REFERENCES messages(id), -- for replies
  is_edited BOOLEAN DEFAULT FALSE,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 6. Message Status Table
```sql
message_status (
  id SERIAL PRIMARY KEY,
  message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL CHECK (status IN ('sent', 'delivered', 'read')), -- delivered means received by recipient device, read means opened
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(message_id, user_id)
);
```

### 7. User Sessions Table
```sql
user_sessions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  token_hash VARCHAR(255) NOT NULL,
  device_info TEXT,
  ip_address INET,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP
);
```

## Relationships

1. A user can have many contacts
2. A user can participate in many chats (through chat_members)
3. A chat can have many members (through chat_members)
4. A chat can have many messages
5. A user can send many messages
6. A message can have many status entries (one for each recipient)
7. A user can have many active sessions

## Key Features Implemented Through Schema

1. **Private Chats**: Two users connected through a chat record
2. **Group Chats**: Multiple users in one chat via chat_members
3. **Message Statuses**: Read/delivered indicators through message_status
4. **Media Support**: Separate fields for content vs media
5. **Blocking**: Implemented in contacts table
6. **Online Status**: is_online field in users table
7. **Message Replies**: replied_to_message_id in messages table
8. **Security**: Session management through user_sessions table

## Indexes for Performance

```sql
-- Indexes for frequently queried columns
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_messages_chat_id_created_at ON messages(chat_id, created_at);
CREATE INDEX idx_message_status_message_id ON message_status(message_id);
CREATE INDEX idx_chat_members_chat_id ON chat_members(chat_id);
CREATE INDEX idx_chats_type ON chats(type);
```

This schema supports all core features of a messaging application while maintaining data integrity and performance considerations.