import 'package:json_annotation/json_annotation.dart';
part 'chat_models.g.dart';

@JsonSerializable()
class Chatroom {
  String? chatroomId;
  String? businessName;
  String? username;
  String? businessId;
  String? userId;
  String? logoUrl;
  String? lastMessageSentBy;
  String? lastMessage;
  int? unreadMessageCount;

  List<String> get splitInitials =>
      username!.contains(',') ? username!.split(',') : username!.split(' ');

  String get userInitials =>
      '${splitInitials[0][0].toUpperCase()}${splitInitials[1][0].toUpperCase()}';

  Chatroom({
    this.businessId,
    this.businessName,
    this.chatroomId,
    this.logoUrl,
    this.userId,
    this.username,
    this.lastMessage,
    this.lastMessageSentBy,
    this.unreadMessageCount,
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) =>
      _$ChatroomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatroomToJson(this);
}

@JsonSerializable()
class Chat {
  String? message;
  String? businessName;
  String? username;
  String? businessId;
  String? userId;
  String? chatId;
  String? sentBy;
  int? time;

  Chat({
    this.message,
    this.chatId,
    this.sentBy,
    this.time,
    this.businessName,
    this.username,
    this.businessId,
    this.userId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
