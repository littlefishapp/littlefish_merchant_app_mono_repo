// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreStory _$StoreStoryFromJson(Map<String, dynamic> json) => StoreStory(
  businessId: json['businessId'] as String?,
  businessLogoUrl: json['businessLogoUrl'] as String?,
  businessName: json['businessName'] as String?,
  content: json['content'] == null
      ? null
      : StoryFile.fromJson(json['content'] as Map<String, dynamic>),
  dateCreated: const DateTimeConverter().fromJson(json['dateCreated']),
  previewImageUrl: json['previewImageUrl'] as String?,
  storyExpiryDate: const DateTimeConverter().fromJson(json['storyExpiryDate']),
  storyId: json['storyId'] as String?,
  title: json['title'] as String?,
  userId: json['userId'] as String?,
  userImageUrl: json['userImageUrl'] as String?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$StoreStoryToJson(
  StoreStory instance,
) => <String, dynamic>{
  'storyId': instance.storyId,
  'businessId': instance.businessId,
  'businessName': instance.businessName,
  'businessLogoUrl': instance.businessLogoUrl,
  'userId': instance.userId,
  'userName': instance.userName,
  'userImageUrl': instance.userImageUrl,
  'dateCreated': const DateTimeConverter().toJson(instance.dateCreated),
  'storyExpiryDate': const DateTimeConverter().toJson(instance.storyExpiryDate),
  'title': instance.title,
  'previewImageUrl': instance.previewImageUrl,
  'content': instance.content?.toJson(),
};

StorePost _$StorePostFromJson(Map<String, dynamic> json) => StorePost(
  businessId: json['businessId'] as String?,
  businessLogoUrl: json['businessLogoUrl'] as String?,
  businessName: json['businessName'] as String?,
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => StoryFile.fromJson(e as Map<String, dynamic>))
      .toList(),
  dateCreated: const DateTimeConverter().fromJson(json['dateCreated']),
  datePosted: const DateTimeConverter().fromJson(json['datePosted']),
  postExpiryDate: const DateTimeConverter().fromJson(json['postExpiryDate']),
  text: json['text'] as String?,
  title: json['title'] as String?,
  userId: json['userId'] as String?,
  userImageUrl: json['userImageUrl'] as String?,
  userName: json['userName'] as String?,
  postId: json['postId'] as String?,
);

Map<String, dynamic> _$StorePostToJson(StorePost instance) => <String, dynamic>{
  'postId': instance.postId,
  'businessId': instance.businessId,
  'businessName': instance.businessName,
  'businessLogoUrl': instance.businessLogoUrl,
  'userId': instance.userId,
  'userName': instance.userName,
  'userImageUrl': instance.userImageUrl,
  'dateCreated': const DateTimeConverter().toJson(instance.dateCreated),
  'datePosted': const DateTimeConverter().toJson(instance.datePosted),
  'postExpiryDate': const DateTimeConverter().toJson(instance.postExpiryDate),
  'title': instance.title,
  'text': instance.text,
  'content': instance.content?.map((e) => e.toJson()).toList(),
};

StoryFile _$StoryFileFromJson(Map<String, dynamic> json) => StoryFile(
  fileType: json['fileType'] as String? ?? 'image',
  postUrl: json['postUrl'] as String?,
);

Map<String, dynamic> _$StoryFileToJson(StoryFile instance) => <String, dynamic>{
  'fileType': instance.fileType,
  'postUrl': instance.postUrl,
};
