import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
import 'promotion.dart';

part 'broadcast.g.dart';

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
class Broadcast extends FirebaseDocumentModel {
  String? id;
  String? message;
  String? title;
  String? imageUrl;
  dynamic broadcastData;
  DateTime? dateCreated;
  String? createdBy;
  Audience? audience;
  String? storeId, topic, storeName;
  CommunicationStream? commStream;

  Broadcast({
    this.message,
    this.title,
    this.imageUrl,
    this.id,
    this.audience,
    this.broadcastData,
    this.topic,
    this.storeId,
    this.createdBy,
    this.dateCreated,
    this.commStream,
  });

  Broadcast.usingState(state) {
    createdBy = state.firebaseUser.uid;
    dateCreated = DateTime.now();
    storeId = topic = state.storeState.store.businessId;
    id = const Uuid().v4();
    storeName = state.storeState.store.displayName;
    commStream = CommunicationStream.create();
  }

  factory Broadcast.fromJson(Map<String, dynamic> json) =>
      _$BroadcastFromJson(json);

  Map<String, dynamic> toJson() => _$BroadcastToJson(this);
}

@JsonSerializable()
class CommunicationStream {
  bool? email, sms, push;

  bool get valid => email! || sms! || push!;

  String get options {
    if (valid) {
      String result = '';
      if (email!) result += 'EMAIL';

      if (sms!) {
        if (isNotBlank(result)) result += ', ';
        result += 'SMS';
      }

      if (push!) {
        if (isNotBlank(result)) result += ', ';

        result += 'PUSH';
      }

      return result;
    } else {
      return 'NONE';
    }
  }

  CommunicationStream({this.email, this.sms, this.push});

  factory CommunicationStream.fromJson(Map<String, dynamic> json) =>
      _$CommunicationStreamFromJson(json);

  Map<String, dynamic> toJson() => _$CommunicationStreamToJson(this);

  CommunicationStream.create() {
    email = sms = false;
    push = true;
  }
}
