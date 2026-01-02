import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';
part 'store_story.g.dart';

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoreStory extends FirebaseDocumentModel {
  StoreStory({
    this.businessId,
    this.businessLogoUrl,
    this.businessName,
    this.content,
    this.dateCreated,
    this.previewImageUrl,
    this.storyExpiryDate,
    this.storyId,
    this.title,
    this.userId,
    this.userImageUrl,
    this.userName,
  });

  String? storyId;

  String? businessId;

  String? businessName;

  String? businessLogoUrl;

  String? userId;

  String? userName;

  String? userImageUrl;

  DateTime? dateCreated;

  //set this to be valid for a period of time that they will pay for
  DateTime? storyExpiryDate;

  String? title;

  String? previewImageUrl;

  StoryFile? content;

  factory StoreStory.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreStoryFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory StoreStory.fromJson(Map<String, dynamic> json) =>
      _$StoreStoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreStoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StorePost {
  StorePost({
    this.businessId,
    this.businessLogoUrl,
    this.businessName,
    this.content,
    this.dateCreated,
    this.datePosted,
    this.postExpiryDate,
    this.text,
    this.title,
    this.userId,
    this.userImageUrl,
    this.userName,
    this.postId,
  });

  String? postId;

  String? businessId;

  String? businessName;

  String? businessLogoUrl;

  String? userId;

  String? userName;

  String? userImageUrl;

  DateTime? dateCreated;

  DateTime? datePosted;

  DateTime? postExpiryDate;

  String? title;

  String? text;

  List<StoryFile>? content;

  factory StorePost.fromJson(Map<String, dynamic> json) =>
      _$StorePostFromJson(json);

  Map<String, dynamic> toJson() => _$StorePostToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoryFile {
  StoryFile({this.fileType = 'image', this.postUrl});

  //image / video
  String? fileType;

  String? postUrl;

  factory StoryFile.fromJson(Map<String, dynamic> json) =>
      _$StoryFileFromJson(json);

  Map<String, dynamic> toJson() => _$StoryFileToJson(this);
}
