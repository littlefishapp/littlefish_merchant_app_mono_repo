// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreNotification _$StoreNotificationFromJson(Map<String, dynamic> json) =>
    StoreNotification(
      title: json['title'] as String?,
      message: json['message'] as String?,
      photoUrl: json['photoUrl'] as String?,
      storeId: json['storeId'] as String?,
      topic: json['topic'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$StoreNotificationToJson(StoreNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'photoUrl': instance.photoUrl,
      'topic': instance.topic,
      'userId': instance.userId,
      'storeId': instance.storeId,
    };
