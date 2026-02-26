import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat.dart';
import '../../models/user.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Add new chat action
            },
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                // Handle logout
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.chats.isEmpty) {
            return const Center(
              child: Text('No chats yet'),
            );
          }
          
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final chat = chatProvider.chats[index];
              return _buildChatItem(chat);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to contacts to start new chat
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    // Determine chat title and avatar
    String title = chat.name ?? '';
    String? avatarUrl = chat.avatarUrl;
    
    if (chat.type == 'private') {
      // For private chats, use the other person's name
      final otherUser = chat.members.firstWhere(
        (member) => member.id != 1, // Assuming current user ID is 1 for now
        orElse: () => chat.members.first,
      );
      title = otherUser.username;
      avatarUrl = otherUser.profilePictureUrl;
    }
    
    // Format last message timestamp
    String timeText = '';
    if (chat.lastMessage != null) {
      timeText = _formatTime(chat.lastMessage!.timestamp);
    }
    
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: avatarUrl != null 
            ? NetworkImage(avatarUrl) as ImageProvider 
            : null,
        child: avatarUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(title),
      subtitle: chat.lastMessage != null
          ? Row(
              children: [
                if (chat.lastMessage!.senderId != 1) // If not sent by current user
                  const Icon(Icons.done_all, size: 14, color: Colors.grey),
                Expanded(
                  child: Text(
                    _getMessagePreview(chat.lastMessage!),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : const Text('New chat'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeText,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (chat.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        // Navigate to chat screen
        // Navigator.of(context).pushNamed('/chat', arguments: chat);
      },
    );
  }

  String _getMessagePreview(Message message) {
    if (message.messageType == 'text') {
      return message.content ?? '';
    } else if (message.messageType == 'image') {
      return '📷 Photo';
    } else if (message.messageType == 'video') {
      return '🎬 Video';
    } else if (message.messageType == 'audio') {
      return '🎵 Audio';
    } else if (message.messageType == 'file') {
      return '📁 File';
    }
    return 'Message';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}