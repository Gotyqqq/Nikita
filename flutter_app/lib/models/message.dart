import 'user.dart';

class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String senderUsername;
  final String? senderProfilePictureUrl;
  final String messageType; // 'text', 'image', 'video', 'file', 'audio'
  final String? content; // for text messages
  final String? mediaUrl; // for media messages
  final String? mediaThumbnailUrl; // for media previews
  final Message? repliedToMessage; // for reply messages
  final bool isEdited;
  final bool isDeleted;
  final String status; // 'sent', 'delivered', 'read'
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderUsername,
    this.senderProfilePictureUrl,
    required this.messageType,
    this.content,
    this.mediaUrl,
    this.mediaThumbnailUrl,
    this.repliedToMessage,
    required this.isEdited,
    required this.isDeleted,
    required this.status,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      senderUsername: json['sender_username'],
      senderProfilePictureUrl: json['sender_profile_picture_url'],
      messageType: json['message_type'],
      content: json['content'],
      mediaUrl: json['media_url'],
      mediaThumbnailUrl: json['media_thumbnail_url'],
      repliedToMessage: json['replied_to_message'] != null
          ? Message.fromJson(json['replied_to_message'])
          : null,
      isEdited: json['is_edited'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      status: json['status'] ?? 'sent',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_username': senderUsername,
      'sender_profile_picture_url': senderProfilePictureUrl,
      'message_type': messageType,
      'content': content,
      'media_url': mediaUrl,
      'media_thumbnail_url': mediaThumbnailUrl,
      'replied_to_message': repliedToMessage?.toJson(),
      'is_edited': isEdited,
      'is_deleted': isDeleted,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Message copyWith({
    int? id,
    int? chatId,
    int? senderId,
    String? senderUsername,
    String? senderProfilePictureUrl,
    String? messageType,
    String? content,
    String? mediaUrl,
    String? mediaThumbnailUrl,
    Message? repliedToMessage,
    bool? isEdited,
    bool? isDeleted,
    String? status,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderProfilePictureUrl: senderProfilePictureUrl ?? this.senderProfilePictureUrl,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaThumbnailUrl: mediaThumbnailUrl ?? this.mediaThumbnailUrl,
      repliedToMessage: repliedToMessage ?? this.repliedToMessage,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}