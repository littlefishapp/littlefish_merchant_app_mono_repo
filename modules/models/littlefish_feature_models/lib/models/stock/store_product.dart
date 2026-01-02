// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:littlefish_merchant/models/shared/firebase_document_model.dart';
// import 'package:littlefish_merchant/models/stock/stock_product.dart';
// import 'package:littlefish_merchant/tools/converters/IsoDateConverter.dart';
// import 'package:uuid/uuid.dart';

// part 'store_product.g.dart';

// @JsonSerializable(explicitToJson: true)
// @IsoDateTimeConverter()
// class StoreProduct with FirebaseDocumentMixin {
//   StoreProduct({
//     this.id,
//     this.averageRating,
//     this.barcode,
//     this.baseCategory,
//     this.businessId,
//     this.compareAtPrice,
//     this.costPrice,
//     this.createdBy,
//     this.dateCreated,
//     this.dateUpdated,
//     this.description,
//     this.displayName,
//     this.featureImageUrl,
//     this.featureVideoUrl,
//     this.gallery,
//     this.inStock,
//     this.isFeatured,
//     this.manageStock,
//     this.name,
//     this.onSale,
//     this.productId,
//     this.productLink,
//     this.ratingCount,
//     this.searchName,
//     this.sellingPrice,
//     this.sku,
//     this.subCategories,
//     this.tags,
//     this.updatedBy,
//     this.variants,
//     this.relatedProducts,
//     this.deleted,
//     this.isNew,
//     this.currencyCode,
//     this.shortCurrencyCode,
//     this.countryCode,
//     this.baseCategoryId,
//     this.featureImageAddress,
//     // this.storeLinks,
//   });

//   //id and product id are the same value
//   String id;

//   String businessId;

//   String currencyCode;

//   String shortCurrencyCode;

//   String countryCode;

//   String productId;

//   String baseCategory, baseCategoryId;

//   DateTime dateCreated, dateUpdated;

//   String createdBy, updatedBy;

//   String name;

//   String displayName;

//   String searchName;

//   String description;

//   String productLink;

//   double costPrice, compareAtPrice, sellingPrice;

//   String sku;

//   String barcode;

//   @JsonKey(defaultValue: false)
//   bool inStock, onSale, manageStock;

//   @JsonKey(defaultValue: false)
//   bool deleted;

//   @JsonKey(includeFromJson: false, includeToJson: false)
//   bool isNew;

//   int ratingCount;

//   double averageRating;

//   String featureImageUrl, featureImageAddress;

//   String featureVideoUrl;

//   @JsonKey(defaultValue: false)
//   bool isFeatured;

//   @JsonKey(defaultValue: <String>[])
//   List<String> subCategories;

//   @JsonKey(defaultValue: <String>[])
//   List<String> gallery;

//   // @JsonKey(defaultValue: <StoreLink>[])
//   // List<StoreLink> storeLinks;

//   @JsonKey(includeFromJson: false, includeToJson: false)
//   bool get hasGallery {
//     if (this.gallery == null || this.gallery.isEmpty) return false;
//     return true;
//   }

//   @JsonKey(defaultValue: <String>[])
//   List<String> tags;

//   @JsonKey(defaultValue: <StoreProductVariation>[])
//   List<StoreProductVariation> variants;

//   @JsonKey(defaultValue: <StoreRelatedProduct>[])
//   List<StoreRelatedProduct> relatedProducts;

//   @JsonKey(includeFromJson: false, includeToJson: false)
//   bool get hasRatings {
//     if (this.ratingCount == null || this.ratingCount <= 0) return false;
//     return true;
//   }

//   factory StoreProduct.fromStockProduct(
//           StockProduct product, String businessId) =>
//       StoreProduct(
//         businessId: businessId,
//         barcode: product.regularBarCode,
//         baseCategoryId: product.categoryId,
//         costPrice: product.regularCostPrice,
//         sellingPrice: product.regularSellingPrice,
//         dateCreated: product.dateCreated,
//         dateUpdated: DateTime.now().toUtc(),
//         createdBy: product.createdBy,
//         deleted: false,
//         description: product.description,
//         displayName: product.displayName,
//         id: product.id,
//         name: product.name,
//         productId: product.id,
//         searchName: product.name,
//         sku: product.sku,
//         // storeLinks: [
//         //   StoreLink(
//         //       localProductId: product.id,
//         //       provider: 'Ecommerce',
//         //       syncProduct: true,
//         //       thirdPartyProductId: product.id,
//         //       config: '')
//         // ]
//       );

//   factory StoreProduct.fromDocumentSnapshot(
//     DocumentSnapshot snapshot, {
//     DocumentReference reference,
//   }) =>
//       _$StoreProductFromJson(
//         snapshot.data(),
//       )
//         ..documentSnapshot = snapshot
//         ..documentReference = reference;

//   factory StoreProduct.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreProductToJson(this);

//   factory StoreProduct.create() {
//     return StoreProduct(
//         manageStock: false,
//         averageRating: 0,
//         ratingCount: 0,
//         inStock: true,
//         isFeatured: false,
//         onSale: false,
//         gallery: List<String>(),
//         deleted: false,
//         isNew: true,
//         variants: List<StoreProductVariation>(),
//         relatedProducts: List<StoreRelatedProduct>(),
//         id: Uuid().v4());
//   }
// }

// @JsonSerializable(explicitToJson: true)
// class StoreLink {
//   StoreLink({
//     this.provider,
//     this.localProductId,
//     this.thirdPartyProductId,
//     this.config,
//     this.syncProduct,
//   });

//   String provider;
//   String localProductId;
//   String thirdPartyProductId;
//   String config;
//   bool syncProduct;

//   factory StoreLink.fromJson(Map<String, dynamic> json) =>
//       _$StoreLinkFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreLinkToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// @IsoDateTimeConverter()
// class StoreRelatedProduct {
//   StoreRelatedProduct({
//     this.featureImageUrl,
//     this.productId,
//     this.productName,
//   });

//   String productId;

//   String featureImageUrl;

//   String productName;

//   factory StoreRelatedProduct.fromJson(Map<String, dynamic> json) =>
//       _$StoreRelatedProductFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreRelatedProductToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// @IsoDateTimeConverter()
// class StoreProductVariation {
//   StoreProductVariation({
//     this.attributes,
//     this.compareAtPrice,
//     this.costPrice,
//     this.featureImageUrl,
//     this.id,
//     this.inStock,
//     this.onSale,
//     this.salePrice,
//     this.sellingPrice,
//     this.sku,
//   });

//   String id;

//   String sku;

//   double sellingPrice;

//   double compareAtPrice;

//   double costPrice;

//   double salePrice;

//   bool onSale;

//   bool inStock;

//   String featureImageUrl;

//   // 0 - color
//   // 1 - size
//   List<StoreProductAttribute> attributes;

//   factory StoreProductVariation.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductVariationFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreProductVariationToJson(this);

//   factory StoreProductVariation.create() {
//     return StoreProductVariation(
//       id: Uuid().v4(),
//       attributes: [StoreProductAttribute()],
//       onSale: false,
//       inStock: true,
//     );
//   }
// }

// @JsonSerializable(explicitToJson: true)
// @IsoDateTimeConverter()
// class StoreProductAttribute {
//   StoreProductAttribute({
//     this.id,
//     this.name,
//     this.option,
//   });

//   int id;
//   String name;
//   String option;

//   factory StoreProductAttribute.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductAttributeFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreProductAttributeToJson(this);

//   factory StoreProductAttribute.create() =>
//       StoreProductAttribute(option: 'Size', name: 'Regular');
// }

// @JsonSerializable(explicitToJson: true)
// @IsoDateTimeConverter()
// class StoreProductCategory {
//   StoreProductCategory({
//     this.businessId,
//     this.categoryId,
//     this.createdBy,
//     this.dateCreated,
//     this.dateUpdated,
//     this.description,
//     this.displayName,
//     this.featureImageUrl,
//     this.name,
//     this.searchName,
//     this.updatedBy,
//     this.id,
//     this.productCount,
//   });

//   String businessId;

//   //category id and id are the same value
//   String categoryId, id;

//   String name;

//   String displayName;

//   String searchName;

//   String description;

//   String featureImageUrl;

//   int productCount;

//   DateTime dateCreated, dateUpdated;

//   @JsonKey(defaultValue: false)
//   bool deleted;

//   String createdBy, updatedBy;

//   factory StoreProductCategory.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductCategoryFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreProductCategoryToJson(this);
// }

// @JsonSerializable(explicitToJson: true)
// @IsoDateTimeConverter()
// class StoreProductRating {
//   StoreProductRating({
//     this.businessId,
//     this.comments,
//     this.rating,
//     this.review,
//     this.reviewDate,
//     this.userId,
//     this.userName,
//   });

//   String businessId;

//   double rating;

//   String review;

//   DateTime reviewDate;

//   String userId;

//   String userName;

//   @JsonKey(defaultValue: [])
//   List<StoreProductRatingComment> comments;

//   factory StoreProductRating.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductRatingFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreProductRatingToJson(this);
// }

// @JsonSerializable()
// @IsoDateTimeConverter()
// class StoreProductRatingComment {
//   StoreProductRatingComment({
//     this.comment,
//     this.commentDate,
//     this.userId,
//     this.userName,
//   });

//   String comment;

//   String userId;

//   String userName;

//   DateTime commentDate;

//   factory StoreProductRatingComment.fromJson(Map<String, dynamic> json) =>
//       _$StoreProductRatingCommentFromJson(json);

//   Map<String, dynamic> toJson() => _$StoreProductRatingCommentToJson(this);
// }
