import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
// @NotificationTypeConverter()
class StoreNotification {
  String? title, message, photoUrl;
  // NotificationType notificationType;

  String? topic;
  String? userId;
  String? storeId;

  StoreNotification({
    this.title,
    this.message,
    // this.notificationType,
    this.photoUrl,
    this.storeId,
    this.topic,
    this.userId,
  });

  factory StoreNotification.fromJson(Map<String, dynamic> json) =>
      _$StoreNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$StoreNotificationToJson(this);
}

enum NotificationType { topic, singleDevice, multipleDevices }

class NotificationTypeConverter
    implements JsonConverter<NotificationType, int> {
  const NotificationTypeConverter();

  @override
  NotificationType fromJson(int json) {
    return NotificationType.values[json];
  }

  @override
  int toJson(NotificationType object) {
    return object.index;
  }
}
