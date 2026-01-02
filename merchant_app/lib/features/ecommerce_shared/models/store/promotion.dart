import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
import 'broadcast.dart';
import 'store.dart';

part 'promotion.g.dart';

@JsonSerializable(explicitToJson: true)
class PromoCountItem {
  @JsonKey(defaultValue: 0)
  int? currentCount, totalCount;
  String? id;

  PromoCountItem({this.currentCount, this.totalCount, this.id});

  factory PromoCountItem.fromJson(Map<String, dynamic> json) =>
      _$PromoCountItemFromJson(json);

  Map<String, dynamic> toJson() => _$PromoCountItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
@PromotionTypeConverter()
class Promotion extends FirebaseDocumentModel {
  String? id;
  String? title, message;
  DateTime? dateRun;
  String? createdBy;
  String? imageUrl, imageAddress;
  int? duration;
  DateTime? startDate;
  DateTime? endDate;
  Audience? audience;
  PromotionData? data;
  PromotionType? type;
  bool? isCancelled;
  bool? deleted;
  StoreInfo? storeInfo;
  CommunicationStream? commStream;

  @JsonKey(defaultValue: [])
  List<String>? likes;

  @JsonKey(defaultValue: 0)
  int? totalLikes;

  @JsonKey(defaultValue: 0)
  int? postViews;

  @JsonKey(defaultValue: [])
  List<Comment>? comments;

  @JsonKey(defaultValue: 0)
  int? totalComments;

  @JsonKey(defaultValue: 0)
  int? totalClicks;

  @JsonKey(defaultValue: true)
  bool? isSponsored;

  Promotion({
    this.dateRun,
    this.id,
    this.message,
    this.title,
    this.type,
    this.createdBy,
    this.duration,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.isSponsored,
    this.imageAddress,
    this.audience,
    this.data,
    this.storeInfo,
    this.isCancelled,
    this.deleted,
    this.commStream,
  });

  Promotion.usingState(state, bool sponsored, {PromotionType? promoType}) {
    createdBy = state.firebaseUser.uid;
    postViews = totalComments = totalClicks = 0;
    isSponsored = sponsored;
    id = const Uuid().v4();
    isCancelled = false;
    storeInfo = StoreInfo.usingStore(state.storeState.store);
    deleted = false;
    commStream = CommunicationStream.create();
    dateRun = DateTime.now();

    if (promoType != null) type = promoType;
  }

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get commentsCollection =>
      documentReference?.collection('comments');

  bool get isExpired => endDate?.isBefore(DateTime.now()) ?? true;
}

@JsonSerializable(explicitToJson: true)
class PromotionData {
  String? itemId;
  String? name;

  PromotionData({this.itemId, this.name});

  factory PromotionData.fromJson(Map<String, dynamic> json) =>
      _$PromotionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StoreInfo {
  String? storeId, storeName;
  String? logoUrl, logoAddress;
  String? coverUrl, coverAddress;
  StoreAddress? primaryAddress;

  StoreInfo({
    this.logoUrl,
    this.logoAddress,
    this.coverUrl,
    this.coverAddress,
    this.primaryAddress,
    this.storeId,
    this.storeName,
  });

  StoreInfo.usingStore(Store store) {
    logoUrl = store.logoUrl;
    logoAddress = store.logoAddress;
    coverUrl = store.coverImageUrl;
    coverAddress = store.coverImageAddress;
    primaryAddress = store.primaryAddress;
    storeName = store.displayName;
    storeId = store.businessId;
  }

  factory StoreInfo.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StoreInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
@AudienceTypeConverter()
class Audience {
  AudienceType? audienceType;
  List<PromotionUser>? users;
  String? topic, topicEasyName;
  String? customerListName, customerListId;

  Audience({
    this.audienceType,
    this.users,
    this.topic,
    this.customerListId,
    this.customerListName,
    this.topicEasyName,
  });

  factory Audience.fromJson(Map<String, dynamic> json) =>
      _$AudienceFromJson(json);

  Map<String, dynamic> toJson() => _$AudienceToJson(this);
}

@JsonSerializable()
class PromotionUser {
  String? displayName, email, id;

  PromotionUser({this.displayName, this.email, this.id});

  factory PromotionUser.fromJson(Map<String, dynamic> json) =>
      _$PromotionUserFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
class PromotionReport extends FirebaseDocumentModel {
  PromotionUser? reportedBy;
  DateTime? dateReported;
  String? promotionId;
  String? id;
  StoreInfo? storeInfo;

  PromotionReport({
    this.dateReported,
    this.id,
    this.promotionId,
    this.reportedBy,
    this.storeInfo,
  });

  PromotionReport.usingState(state, Promotion promo) {
    id = const Uuid().v4();
    reportedBy = PromotionUser(
      id: state.firebaseUser.uid,
      email: state.firebaseUser.email,
      displayName: state.userProfile.displayName,
    );
    dateReported = DateTime.now();
    promotionId = promo.id;
    storeInfo = promo.storeInfo;
  }

  factory PromotionReport.fromJson(Map<String, dynamic> json) =>
      _$PromotionReportFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionReportToJson(this);
}

@JsonSerializable()
@EpochDateTimeConverter()
class Comment {
  String? userId;
  String? firstName, lastName;
  String? id;
  String? comment;
  DateTime? dateCreated;

  String get displayName => '$firstName $lastName';

  Comment({
    this.userId,
    this.id,
    this.comment,
    this.firstName,
    this.lastName,
    this.dateCreated,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

enum AudienceType { specific, topic, list }

enum PromotionType { post, product, category, coupon }

class PromotionTypeConverter implements JsonConverter<PromotionType?, String> {
  const PromotionTypeConverter();

  @override
  PromotionType? fromJson(String? json) {
    return PromotionType.values.firstWhereOrNull(
      (element) => element.toString().split('.').last == json,
    );
  }

  @override
  String toJson(PromotionType? object) {
    return object.toString().split('.').last;
  }
}

class AudienceTypeConverter implements JsonConverter<AudienceType?, String> {
  const AudienceTypeConverter();

  @override
  AudienceType? fromJson(String? json) {
    return AudienceType.values.firstWhereOrNull(
      (element) => element.toString().split('.').last == json,
    );
  }

  @override
  String toJson(AudienceType? object) {
    return object.toString().split('.').last;
  }
}
