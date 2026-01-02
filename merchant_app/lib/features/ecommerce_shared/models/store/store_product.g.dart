// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreProduct _$StoreProductFromJson(Map<String, dynamic> json) =>
    StoreProduct(
        id: json['id'] as String?,
        averageRating: (json['averageRating'] as num?)?.toDouble(),
        barcode: json['barcode'] as String?,
        baseCategory: json['baseCategory'] as String?,
        businessId: json['businessId'] as String?,
        compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble() ?? 0.0,
        costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
        createdBy: json['createdBy'] as String?,
        dateCreated: const EpochDateTimeConverter().fromJson(
          json['dateCreated'],
        ),
        dateUpdated: const EpochDateTimeConverter().fromJson(
          json['dateUpdated'],
        ),
        description: json['description'] as String?,
        displayName: json['displayName'] as String?,
        featureImageUrl: json['featureImageUrl'] as String?,
        featureVideoUrl: json['featureVideoUrl'] as String?,
        gallery:
            (json['gallery'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        inStock: json['inStock'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
        manageStock: json['manageStock'] as bool? ?? false,
        name: json['name'] as String?,
        onSale: json['onSale'] as bool? ?? false,
        productId: json['productId'] as String?,
        productLink: json['productLink'] as String?,
        ratingCount: (json['ratingCount'] as num?)?.toInt(),
        searchName: json['searchName'] as String?,
        sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
        sku: json['sku'] as String?,
        subCategories:
            (json['subCategories'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        updatedBy: json['updatedBy'] as String?,
        relatedProducts:
            (json['relatedProducts'] as List<dynamic>?)
                ?.map(
                  (e) =>
                      StoreRelatedProduct.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
        deleted: json['deleted'] as bool? ?? false,
        currencyCode: json['currencyCode'] as String?,
        shortCurrencyCode: json['shortCurrencyCode'] as String?,
        countryCode: json['countryCode'] as String?,
        productSettings: json['productSettings'] == null
            ? null
            : StoreProductSettings.fromJson(
                json['productSettings'] as Map<String, dynamic>,
              ),
        storeProductVariantType: json['storeProductVariantType'] == null
            ? StoreProductVariantType.standalone
            : const StoreProductVariantTypeConverter().fromJson(
                json['storeProductVariantType'] as String?,
              ),
        productVariant: json['productVariant'] == null
            ? null
            : ProductVariant.fromJson(
                json['productVariant'] as Map<String, dynamic>,
              ),
      )
      ..baseCategoryId = json['baseCategoryId'] as String?
      ..featureImageAddress = json['featureImageAddress'] as String?;

Map<String, dynamic> _$StoreProductToJson(
  StoreProduct instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'currencyCode': instance.currencyCode,
  'shortCurrencyCode': instance.shortCurrencyCode,
  'countryCode': instance.countryCode,
  'storeProductVariantType': const StoreProductVariantTypeConverter().toJson(
    instance.storeProductVariantType,
  ),
  'productVariant': instance.productVariant?.toJson(),
  'productId': instance.productId,
  'baseCategory': instance.baseCategory,
  'baseCategoryId': instance.baseCategoryId,
  'dateCreated': const EpochDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const EpochDateTimeConverter().toJson(instance.dateUpdated),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'name': instance.name,
  'displayName': instance.displayName,
  'searchName': instance.searchName,
  'description': instance.description,
  'productLink': instance.productLink,
  'costPrice': instance.costPrice,
  'compareAtPrice': instance.compareAtPrice,
  'sellingPrice': instance.sellingPrice,
  'sku': instance.sku,
  'barcode': instance.barcode,
  'inStock': instance.inStock,
  'onSale': instance.onSale,
  'manageStock': instance.manageStock,
  'deleted': instance.deleted,
  'ratingCount': instance.ratingCount,
  'averageRating': instance.averageRating,
  'featureImageUrl': instance.featureImageUrl,
  'featureImageAddress': instance.featureImageAddress,
  'featureVideoUrl': instance.featureVideoUrl,
  'productSettings': instance.productSettings?.toJson(),
  'isFeatured': instance.isFeatured,
  'subCategories': instance.subCategories,
  'gallery': instance.gallery,
  'relatedProducts': instance.relatedProducts?.map((e) => e.toJson()).toList(),
};

StoreRelatedProduct _$StoreRelatedProductFromJson(Map<String, dynamic> json) =>
    StoreRelatedProduct(
      featureImageUrl: json['featureImageUrl'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
    );

Map<String, dynamic> _$StoreRelatedProductToJson(
  StoreRelatedProduct instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'featureImageUrl': instance.featureImageUrl,
  'productName': instance.productName,
};

StoreProductAttribute _$StoreProductAttributeFromJson(
  Map<String, dynamic> json,
) => StoreProductAttribute(
  id: json['id'] as String?,
  name: json['name'] as String?,
  option: json['option'] as String?,
);

Map<String, dynamic> _$StoreProductAttributeToJson(
  StoreProductAttribute instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'option': instance.option,
};

StoreProductTag _$StoreProductTagFromJson(Map<String, dynamic> json) =>
    StoreProductTag(id: json['id'] as String?, tag: json['tag'] as String?);

Map<String, dynamic> _$StoreProductTagToJson(StoreProductTag instance) =>
    <String, dynamic>{'id': instance.id, 'tag': instance.tag};

StoreProductCategory _$StoreProductCategoryFromJson(
  Map<String, dynamic> json,
) => StoreProductCategory(
  businessId: json['businessId'] as String?,
  categoryId: json['categoryId'] as String?,
  createdBy: json['createdBy'] as String?,
  dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
  dateUpdated: const IsoDateTimeConverter().fromJson(json['dateUpdated']),
  description: json['description'] as String?,
  displayName: json['displayName'] as String?,
  featureImageUrl: json['featureImageUrl'] as String?,
  name: json['name'] as String?,
  searchName: json['searchName'] as String?,
  updatedBy: json['updatedBy'] as String?,
  id: json['id'] as String?,
  productCount: (json['productCount'] as num?)?.toInt() ?? 0,
  storeSubtypeId: json['storeSubtypeId'] as String?,
  productTypeCount: (json['productTypeCount'] as num?)?.toInt() ?? 0,
)..deleted = json['deleted'] as bool? ?? false;

Map<String, dynamic> _$StoreProductCategoryToJson(
  StoreProductCategory instance,
) => <String, dynamic>{
  'businessId': instance.businessId,
  'categoryId': instance.categoryId,
  'id': instance.id,
  'name': instance.name,
  'displayName': instance.displayName,
  'searchName': instance.searchName,
  'storeSubtypeId': instance.storeSubtypeId,
  'description': instance.description,
  'featureImageUrl': instance.featureImageUrl,
  'productCount': instance.productCount,
  'productTypeCount': instance.productTypeCount,
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'deleted': instance.deleted,
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
};

StoreProductRating _$StoreProductRatingFromJson(Map<String, dynamic> json) =>
    StoreProductRating(
      businessId: json['businessId'] as String?,
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map(
                (e) => StoreProductRatingComment.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'] as String?,
      reviewDate: const DateTimeConverter().fromJson(json['reviewDate']),
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      productId: json['productId'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$StoreProductRatingToJson(StoreProductRating instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'businessId': instance.businessId,
      'rating': instance.rating,
      'review': instance.review,
      'reviewDate': const DateTimeConverter().toJson(instance.reviewDate),
      'userId': instance.userId,
      'userName': instance.userName,
      'displayName': instance.displayName,
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
    };

StoreProductRatingComment _$StoreProductRatingCommentFromJson(
  Map<String, dynamic> json,
) => StoreProductRatingComment(
  comment: json['comment'] as String?,
  commentDate: const DateTimeConverter().fromJson(json['commentDate']),
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map(
            (e) =>
                StoreProductRatingComment.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$StoreProductRatingCommentToJson(
  StoreProductRatingComment instance,
) => <String, dynamic>{
  'comment': instance.comment,
  'userId': instance.userId,
  'userName': instance.userName,
  'commentDate': const DateTimeConverter().toJson(instance.commentDate),
  'comments': instance.comments,
};

StoreProductSettings _$StoreProductSettingsFromJson(
  Map<String, dynamic> json,
) => StoreProductSettings(
  allowComments: json['allowComments'] as bool? ?? false,
  allowReview: json['allowReview'] as bool? ?? true,
  allowWishList: json['allowWishList'] as bool? ?? true,
  showInStock: json['showInStock'] as bool? ?? false,
  trackViews: json['trackViews'] as bool? ?? true,
);

Map<String, dynamic> _$StoreProductSettingsToJson(
  StoreProductSettings instance,
) => <String, dynamic>{
  'allowReview': instance.allowReview,
  'allowComments': instance.allowComments,
  'showInStock': instance.showInStock,
  'allowWishList': instance.allowWishList,
  'trackViews': instance.trackViews,
};

PriceList _$PriceListFromJson(Map<String, dynamic> json) => PriceList(
  id: json['id'] as String?,
  name: json['name'] as String?,
  displayName: json['displayName'] as String?,
  dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
  description: json['description'] as String?,
  searchName: json['searchName'] as String?,
  totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
  deleted: json['deleted'] as bool?,
  compareAtPrice: (json['compareAtPrice'] as num?)?.toDouble(),
  costPrice: (json['costPrice'] as num?)?.toDouble(),
  sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PriceListToJson(PriceList instance) => <String, dynamic>{
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'id': instance.id,
  'name': instance.name,
  'displayName': instance.displayName,
  'searchName': instance.searchName,
  'description': instance.description,
  'deleted': instance.deleted,
  'sellingPrice': instance.sellingPrice,
  'costPrice': instance.costPrice,
  'compareAtPrice': instance.compareAtPrice,
  'totalProducts': instance.totalProducts,
};

PriceListLink _$PriceListLinkFromJson(Map<String, dynamic> json) =>
    PriceListLink(
      productId: json['productId'] as String?,
      listId: json['listId'] as String?,
      displayName: json['displayName'] as String?,
      dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$PriceListLinkToJson(PriceListLink instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'listId': instance.listId,
      'displayName': instance.displayName,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'imageUrl': instance.imageUrl,
    };

ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) =>
    ProductVariant(
      variantCombinations: (json['variantCombinations'] as List<dynamic>?)
          ?.map((e) => ProductVariantLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      variantTitles: (json['variantTitles'] as List<dynamic>?)
          ?.map((e) => VariantTitle.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCombinations: (json['totalCombinations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      selectedVariant: json['selectedVariant'] == null
          ? null
          : ProductVariantLink.fromJson(
              json['selectedVariant'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProductVariantToJson(ProductVariant instance) =>
    <String, dynamic>{
      'variantTitles': instance.variantTitles,
      'variantCombinations': instance.variantCombinations,
      'products': instance.products,
      'totalCombinations': instance.totalCombinations,
      'selectedVariant': instance.selectedVariant,
    };

VariantTitle _$VariantTitleFromJson(Map<String, dynamic> json) => VariantTitle(
  name: json['name'] as String?,
  values: (json['values'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$VariantTitleToJson(VariantTitle instance) =>
    <String, dynamic>{'name': instance.name, 'values': instance.values};

ProductVariantLink _$ProductVariantLinkFromJson(Map<String, dynamic> json) =>
    ProductVariantLink(
      price: (json['price'] as num?)?.toDouble(),
      productId: json['productId'] as String?,
      sku: json['sku'] as String?,
      variant: json['variant'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ProductVariantLinkToJson(ProductVariantLink instance) =>
    <String, dynamic>{
      'variant': instance.variant,
      'sku': instance.sku,
      'productId': instance.productId,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
    };
