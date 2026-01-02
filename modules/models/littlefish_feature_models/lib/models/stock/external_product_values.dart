import 'package:json_annotation/json_annotation.dart';
part 'external_product_values.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalProductValues {
  int? rating;
  String? shortCurrencyCode;
  bool? isNew;
  int? ratingCount;
  double? averageRating;
  bool? isFeatured;
  bool? onSale;
  ProductSettings? productSettings;
  List<ProductView>? views;
  List<ProductReview>? reviews;
  List<RelatedProduct>? relatedProducts;

  ExternalProductValues({
    this.rating,
    this.shortCurrencyCode,
    this.isNew,
    this.ratingCount,
    this.averageRating,
    this.isFeatured,
    this.onSale,
    this.productSettings,
    this.views,
    this.reviews,
    this.relatedProducts,
  });

  factory ExternalProductValues.fromJson(Map<String, dynamic> json) =>
      _$ExternalProductValuesFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalProductValuesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductSettings {
  bool? allowComments;
  bool? allowReview;
  bool? allowWishList;
  bool? showInStock;
  bool? trackViews;

  ProductSettings({
    this.allowComments,
    this.allowReview,
    this.allowWishList,
    this.showInStock,
    this.trackViews,
  });

  factory ProductSettings.fromJson(Map<String, dynamic> json) =>
      _$ProductSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSettingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RelatedProduct {
  String? productId;
  String? productName;
  String? featureImageUrl;

  RelatedProduct({this.productId, this.productName, this.featureImageUrl});

  factory RelatedProduct.fromJson(Map<String, dynamic> json) =>
      _$RelatedProductFromJson(json);
  Map<String, dynamic> toJson() => _$RelatedProductToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductView {
  String? id;
  String? productId;
  String? productName;
  String? storeId;
  String? timeViewed;
  String? userId;

  ProductView({
    this.id,
    this.productId,
    this.productName,
    this.storeId,
    this.timeViewed,
    this.userId,
  });

  factory ProductView.fromJson(Map<String, dynamic> json) =>
      _$ProductViewFromJson(json);
  Map<String, dynamic> toJson() => _$ProductViewToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductReview {
  String? id;
  String? image;
  String? businessId;
  String? displayName;
  String? productId;
  int? rating;
  String? review;
  DateTime? reviewDate;
  String? userId;
  String? userName;

  ProductReview({
    this.id,
    this.image,
    this.businessId,
    this.displayName,
    this.productId,
    this.rating,
    this.review,
    this.reviewDate,
    this.userId,
    this.userName,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ProductReviewToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductIDsRequest {
  List<String>? productIds;
  String? businessId;

  ProductIDsRequest({this.productIds, this.businessId});

  factory ProductIDsRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductIDsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ProductIDsRequestToJson(this);
}
