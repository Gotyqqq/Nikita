import 'user.dart';
import 'message.dart';

class Chat {
  final int id;
  final String type; // 'private' or 'group'
  final String? name; // for group chats
  final String? description; // for group chats
  final String? avatarUrl;
  final int unreadCount;
  final Message? lastMessage;
  final List<User> members;
  final DateTime createdAt;

  Chat({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.avatarUrl,
    required this.unreadCount,
    this.lastMessage,
    required this.members,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      avatarUrl: json['avatar_url'],
      unreadCount: json['unread_count'] ?? 0,
      lastMessage: json['last_message'] != null 
          ? Message.fromJson(json['last_message']) 
          : null,
      members: (json['members'] as List<dynamic>?)
              ?.map((member) => User.fromJson(member))
              .toList() ?? [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
      'unread_count': unreadCount,
      'last_message': lastMessage?.toJson(),
      'members': members.map((member) => member.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Chat copyWith({
    int? id,
    String? type,
    String? name,
    String? description,
    String? avatarUrl,
    int? unreadCount,
    Message? lastMessage,
    List<User>? members,
    DateTime? createdAt,
  }) {
    return Chat(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}