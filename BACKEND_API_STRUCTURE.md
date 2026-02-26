# Backend API Structure for Nikita App

## API Base URL
`https://api.nikitaapp.com/v1`

## Authentication
All endpoints (except login/register) require a valid JWT token in the header:
```
Authorization: Bearer {token}
```

## API Endpoints

### 1. User Management

#### Register User
- **POST** `/auth/register`
- Headers: `Content-Type: application/json`
- Request Body:
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "securePassword123",
  "phone_number": "+1234567890"
}
```
- Response:
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "profile_picture_url": null,
      "created_at": "2023-01-01T00:00:00.000Z"
    },
    "access_token": "jwt_access_token",
    "refresh_token": "jwt_refresh_token"
  }
}
```

#### Login User
- **POST** `/auth/login`
- Headers: `Content-Type: application/json`
- Request Body:
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```
- Response:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "username": "johndoe",
      "email": "john@example.com",
      "profile_picture_url": null,
      "is_online": true
    },
    "access_token": "jwt_access_token",
    "refresh_token": "jwt_refresh_token"
  }
}
```

#### Get User Profile
- **GET** `/users/profile`
- Response:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "phone_number": "+1234567890",
    "profile_picture_url": "https://cloudinary.com/image.jpg",
    "status": "Available",
    "is_online": true,
    "last_seen": "2023-01-01T10:30:00.000Z"
  }
}
```

#### Update User Profile
- **PUT** `/users/profile`
- Request Body:
```json
{
  "username": "johndoe_updated",
  "status": "Busy",
  "profile_picture_url": "https://cloudinary.com/new_image.jpg"
}
```

### 2. Contacts Management

#### Add Contact
- **POST** `/contacts`
- Request Body:
```json
{
  "contact_username": "janedoe"
}
```
- Response:
```json
{
  "success": true,
  "message": "Contact added successfully",
  "data": {
    "contact": {
      "id": 2,
      "user_id": 1,
      "contact_user_id": 5,
      "nickname": null,
      "is_blocked": false,
      "created_at": "2023-01-01T00:00:00.000Z"
    }
  }
}
```

#### Get Contacts List
- **GET** `/contacts`
- Response:
```json
{
  "success": true,
  "data": [
    {
      "id": 2,
      "username": "janedoe",
      "email": "jane@example.com",
      "profile_picture_url": "https://cloudinary.com/jane.jpg",
      "status": "Online",
      "is_online": true,
      "last_seen": "2023-01-01T10:25:00.000Z",
      "nickname": "Jane",
      "is_blocked": false
    }
  ]
}
```

#### Remove Contact
- **DELETE** `/contacts/{contactId}`

#### Block Contact
- **PATCH** `/contacts/{contactId}/block`

#### Unblock Contact
- **PATCH** `/contacts/{contactId}/unblock`

### 3. Chat Management

#### Create Group Chat
- **POST** `/chats/group`
- Request Body:
```json
{
  "name": "Family Group",
  "description": "Chat with family members",
  "avatar_url": "https://cloudinary.com/family_avatar.jpg",
  "member_usernames": ["alice", "bob", "charlie"]
}
```

#### Get User Chats
- **GET** `/chats`
- Query Parameters: `page=1&limit=20`
- Response:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": "private",
      "name": "Jane Doe",
      "avatar_url": "https://cloudinary.com/jane.jpg",
      "unread_count": 3,
      "last_message": {
        "id": 150,
        "sender_id": 5,
        "sender_username": "janedoe",
        "content": "Hey there!",
        "message_type": "text",
        "timestamp": "2023-01-01T10:30:00.000Z",
        "is_read": false
      },
      "members": [
        {"id": 1, "username": "johndoe"},
        {"id": 5, "username": "janedoe"}
      ]
    },
    {
      "id": 2,
      "type": "group",
      "name": "Family Group",
      "description": "Chat with family members",
      "avatar_url": "https://cloudinary.com/family_avatar.jpg",
      "unread_count": 0,
      "last_message": {
        "id": 145,
        "sender_id": 3,
        "sender_username": "alice",
        "content": "See you tomorrow!",
        "message_type": "text",
        "timestamp": "2023-01-01T09:15:00.000Z",
        "is_read": true
      },
      "members": [
        {"id": 1, "username": "johndoe"},
        {"id": 3, "username": "alice"},
        {"id": 4, "username": "bob"},
        {"id": 5, "username": "charlie"}
      ]
    }
  ]
}
```

#### Get Chat Details
- **GET** `/chats/{chatId}`
- Response:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "type": "private",
    "name": "Jane Doe",
    "avatar_url": "https://cloudinary.com/jane.jpg",
    "created_at": "2023-01-01T08:00:00.000Z",
    "members": [
      {
        "id": 1,
        "username": "johndoe",
        "profile_picture_url": "https://cloudinary.com/john.jpg",
        "is_online": true,
        "last_seen": "2023-01-01T10:30:00.000Z"
      },
      {
        "id": 5,
        "username": "janedoe",
        "profile_picture_url": "https://cloudinary.com/jane.jpg",
        "is_online": false,
        "last_seen": "2023-01-01T10:25:00.000Z"
      }
    ]
  }
}
```

### 4. Message Management

#### Send Message
- **POST** `/messages`
- Request Body:
```json
{
  "chat_id": 1,
  "message_type": "text", // or "image", "video", etc.
  "content": "Hello there!",
  "media_url": null, // for media messages
  "replied_to_message_id": null // for reply messages
}
```
- Response:
```json
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "id": 151,
    "chat_id": 1,
    "sender_id": 1,
    "message_type": "text",
    "content": "Hello there!",
    "media_url": null,
    "replied_to_message_id": null,
    "is_edited": false,
    "is_deleted": false,
    "created_at": "2023-01-01T10:31:00.000Z",
    "updated_at": "2023-01-01T10:31:00.000Z"
  }
}
```

#### Get Chat Messages
- **GET** `/chats/{chatId}/messages`
- Query Parameters: `page=1&limit=50&before_timestamp=2023-01-01T10:30:00.000Z`
- Response:
```json
{
  "success": true,
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 150,
    "has_more": true
  },
  "data": [
    {
      "id": 148,
      "sender_id": 5,
      "sender_username": "janedoe",
      "sender_profile_picture_url": "https://cloudinary.com/jane.jpg",
      "message_type": "text",
      "content": "How are you?",
      "media_url": null,
      "media_thumbnail_url": null,
      "replied_to_message": null,
      "is_edited": false,
      "is_deleted": false,
      "timestamp": "2023-01-01T10:28:00.000Z",
      "status": "read" // for sender, indicates if recipient read it
    },
    {
      "id": 149,
      "sender_id": 1,
      "sender_username": "johndoe",
      "sender_profile_picture_url": "https://cloudinary.com/john.jpg",
      "message_type": "text",
      "content": "I'm doing great, thanks!",
      "media_url": null,
      "media_thumbnail_url": null,
      "replied_to_message": {
        "id": 148,
        "sender_username": "janedoe",
        "content": "How are you?"
      },
      "is_edited": false,
      "is_deleted": false,
      "timestamp": "2023-01-01T10:29:00.000Z",
      "status": "read"
    },
    {
      "id": 150,
      "sender_id": 5,
      "sender_username": "janedoe",
      "sender_profile_picture_url": "https://cloudinary.com/jane.jpg",
      "message_type": "text",
      "content": "Hey there!",
      "media_url": null,
      "media_thumbnail_url": null,
      "replied_to_message": null,
      "is_edited": false,
      "is_deleted": false,
      "timestamp": "2023-01-01T10:30:00.000Z",
      "status": "delivered" // this message hasn't been read yet
    }
  ]
}
```

#### Update Message
- **PUT** `/messages/{messageId}`
- Request Body:
```json
{
  "content": "Updated message content"
}
```

#### Delete Message
- **DELETE** `/messages/{messageId}`

#### Mark Messages as Read
- **POST** `/messages/mark-read`
- Request Body:
```json
{
  "chat_id": 1,
  "up_to_message_id": 150
}
```

### 5. Real-time Events (Socket.io)

#### Connect to Socket
Client connects to: `wss://api.nikitaapp.com`

#### Events Received by Client

##### New Message
```json
{
  "event": "new_message",
  "data": {
    "id": 152,
    "chat_id": 1,
    "sender_id": 5,
    "sender_username": "janedoe",
    "sender_profile_picture_url": "https://cloudinary.com/jane.jpg",
    "message_type": "text",
    "content": "New message!",
    "media_url": null,
    "replied_to_message_id": null,
    "timestamp": "2023-01-01T10:32:00.000Z"
  }
}
```

##### Message Status Updated
```json
{
  "event": "message_status_updated",
  "data": {
    "message_id": 151,
    "status": "delivered" // or "read"
  }
}
```

##### User Online Status Changed
```json
{
  "event": "user_status_changed",
  "data": {
    "user_id": 5,
    "username": "janedoe",
    "is_online": true,
    "last_seen": "2023-01-01T10:32:00.000Z"
  }
}
```

##### New Chat Created
```json
{
  "event": "new_chat",
  "data": {
    "id": 3,
    "type": "private",
    "name": "New Contact",
    "avatar_url": "https://cloudinary.com/contact.jpg",
    "members": [...]
  }
}
```

#### Events Sent by Client

##### Typing Indicator
```json
{
  "event": "typing_start",
  "data": {
    "chat_id": 1
  }
}
```

```json
{
  "event": "typing_stop",
  "data": {
    "chat_id": 1
  }
}
```

##### Mark Chat as Read
```json
{
  "event": "mark_chat_read",
  "data": {
    "chat_id": 1
  }
}
```

## Error Responses
Standard error format:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_INPUT",
    "message": "Invalid email format provided",
    "details": {
      "field": "email",
      "value": "invalid-email"
    }
  }
}
```

Common error codes:
- `INVALID_INPUT`: Validation failed
- `UNAUTHORIZED`: Invalid or expired token
- `FORBIDDEN`: Insufficient permissions
- `NOT_FOUND`: Resource not found
- `CONFLICT`: Duplicate resource or constraint violation
- `INTERNAL_ERROR`: Server-side error