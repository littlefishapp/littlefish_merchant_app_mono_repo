// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_product_values.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalProductValues _$ExternalProductValuesFromJson(
  Map<String, dynamic> json,
) => ExternalProductValues(
  rating: (json['rating'] as num?)?.toInt(),
  shortCurrencyCode: json['shortCurrencyCode'] as String?,
  isNew: json['isNew'] as bool?,
  ratingCount: (json['ratingCount'] as num?)?.toInt(),
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  isFeatured: json['isFeatured'] as bool?,
  onSale: json['onSale'] as bool?,
  productSettings: json['productSettings'] == null
      ? null
      : ProductSettings.fromJson(
          json['productSettings'] as Map<String, dynamic>,
        ),
  views: (json['views'] as List<dynamic>?)
      ?.map((e) => ProductView.fromJson(e as Map<String, dynamic>))
      .toList(),
  reviews: (json['reviews'] as List<dynamic>?)
      ?.map((e) => ProductReview.fromJson(e as Map<String, dynamic>))
      .toList(),
  relatedProducts: (json['relatedProducts'] as List<dynamic>?)
      ?.map((e) => RelatedProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExternalProductValuesToJson(
  ExternalProductValues instance,
) => <String, dynamic>{
  'rating': instance.rating,
  'shortCurrencyCode': instance.shortCurrencyCode,
  'isNew': instance.isNew,
  'ratingCount': instance.ratingCount,
  'averageRating': instance.averageRating,
  'isFeatured': instance.isFeatured,
  'onSale': instance.onSale,
  'productSettings': instance.productSettings?.toJson(),
  'views': instance.views?.map((e) => e.toJson()).toList(),
  'reviews': instance.reviews?.map((e) => e.toJson()).toList(),
  'relatedProducts': instance.relatedProducts?.map((e) => e.toJson()).toList(),
};

ProductSettings _$ProductSettingsFromJson(Map<String, dynamic> json) =>
    ProductSettings(
      allowComments: json['allowComments'] as bool?,
      allowReview: json['allowReview'] as bool?,
      allowWishList: json['allowWishList'] as bool?,
      showInStock: json['showInStock'] as bool?,
      trackViews: json['trackViews'] as bool?,
    );

Map<String, dynamic> _$ProductSettingsToJson(ProductSettings instance) =>
    <String, dynamic>{
      'allowComments': instance.allowComments,
      'allowReview': instance.allowReview,
      'allowWishList': instance.allowWishList,
      'showInStock': instance.showInStock,
      'trackViews': instance.trackViews,
    };

RelatedProduct _$RelatedProductFromJson(Map<String, dynamic> json) =>
    RelatedProduct(
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      featureImageUrl: json['featureImageUrl'] as String?,
    );

Map<String, dynamic> _$RelatedProductToJson(RelatedProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'featureImageUrl': instance.featureImageUrl,
    };

ProductView _$ProductViewFromJson(Map<String, dynamic> json) => ProductView(
  id: json['id'] as String?,
  productId: json['productId'] as String?,
  productName: json['productName'] as String?,
  storeId: json['storeId'] as String?,
  timeViewed: json['timeViewed'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$ProductViewToJson(ProductView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'storeId': instance.storeId,
      'timeViewed': instance.timeViewed,
      'userId': instance.userId,
    };

ProductReview _$ProductReviewFromJson(Map<String, dynamic> json) =>
    ProductReview(
      id: json['id'] as String?,
      image: json['image'] as String?,
      businessId: json['businessId'] as String?,
      displayName: json['displayName'] as String?,
      productId: json['productId'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      review: json['review'] as String?,
      reviewDate: json['reviewDate'] == null
          ? null
          : DateTime.parse(json['reviewDate'] as String),
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$ProductReviewToJson(ProductReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'businessId': instance.businessId,
      'displayName': instance.displayName,
      'productId': instance.productId,
      'rating': instance.rating,
      'review': instance.review,
      'reviewDate': instance.reviewDate?.toIso8601String(),
      'userId': instance.userId,
      'userName': instance.userName,
    };

ProductIDsRequest _$ProductIDsRequestFromJson(Map<String, dynamic> json) =>
    ProductIDsRequest(
      productIds: (json['productIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      businessId: json['businessId'] as String?,
    );

Map<String, dynamic> _$ProductIDsRequestToJson(ProductIDsRequest instance) =>
    <String, dynamic>{
      'productIds': instance.productIds,
      'businessId': instance.businessId,
    };
