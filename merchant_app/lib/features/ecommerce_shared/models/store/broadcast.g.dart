// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Broadcast _$BroadcastFromJson(Map<String, dynamic> json) => Broadcast(
  message: json['message'] as String?,
  title: json['title'] as String?,
  imageUrl: json['imageUrl'] as String?,
  id: json['id'] as String?,
  audience: json['audience'] == null
      ? null
      : Audience.fromJson(json['audience'] as Map<String, dynamic>),
  broadcastData: json['broadcastData'],
  topic: json['topic'] as String?,
  storeId: json['storeId'] as String?,
  createdBy: json['createdBy'] as String?,
  dateCreated: const EpochDateTimeConverter().fromJson(json['dateCreated']),
  commStream: json['commStream'] == null
      ? null
      : CommunicationStream.fromJson(
          json['commStream'] as Map<String, dynamic>,
        ),
)..storeName = json['storeName'] as String?;

Map<String, dynamic> _$BroadcastToJson(Broadcast instance) => <String, dynamic>{
  'id': instance.id,
  'message': instance.message,
  'title': instance.title,
  'imageUrl': instance.imageUrl,
  'broadcastData': instance.broadcastData,
  'dateCreated': const EpochDateTimeConverter().toJson(instance.dateCreated),
  'createdBy': instance.createdBy,
  'audience': instance.audience?.toJson(),
  'storeId': instance.storeId,
  'topic': instance.topic,
  'storeName': instance.storeName,
  'commStream': instance.commStream?.toJson(),
};

CommunicationStream _$CommunicationStreamFromJson(Map<String, dynamic> json) =>
    CommunicationStream(
      email: json['email'] as bool?,
      sms: json['sms'] as bool?,
      push: json['push'] as bool?,
    );

Map<String, dynamic> _$CommunicationStreamToJson(
  CommunicationStream instance,
) => <String, dynamic>{
  'email': instance.email,
  'sms': instance.sms,
  'push': instance.push,
};
