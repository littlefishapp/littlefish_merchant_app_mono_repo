// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chatroom _$ChatroomFromJson(Map<String, dynamic> json) => Chatroom(
  businessId: json['businessId'] as String?,
  businessName: json['businessName'] as String?,
  chatroomId: json['chatroomId'] as String?,
  logoUrl: json['logoUrl'] as String?,
  userId: json['userId'] as String?,
  username: json['username'] as String?,
  lastMessage: json['lastMessage'] as String?,
  lastMessageSentBy: json['lastMessageSentBy'] as String?,
  unreadMessageCount: (json['unreadMessageCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChatroomToJson(Chatroom instance) => <String, dynamic>{
  'chatroomId': instance.chatroomId,
  'businessName': instance.businessName,
  'username': instance.username,
  'businessId': instance.businessId,
  'userId': instance.userId,
  'logoUrl': instance.logoUrl,
  'lastMessageSentBy': instance.lastMessageSentBy,
  'lastMessage': instance.lastMessage,
  'unreadMessageCount': instance.unreadMessageCount,
};

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  message: json['message'] as String?,
  chatId: json['chatId'] as String?,
  sentBy: json['sentBy'] as String?,
  time: (json['time'] as num?)?.toInt(),
  businessName: json['businessName'] as String?,
  username: json['username'] as String?,
  businessId: json['businessId'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'message': instance.message,
  'businessName': instance.businessName,
  'username': instance.username,
  'businessId': instance.businessId,
  'userId': instance.userId,
  'chatId': instance.chatId,
  'sentBy': instance.sentBy,
  'time': instance.time,
};
