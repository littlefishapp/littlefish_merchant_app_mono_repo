import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:uuid/uuid.dart';
import 'package:quiver/strings.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';

part 'store_product.g.dart';

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
@StoreProductVariantTypeConverter()
class StoreProduct with FirebaseDocumentMixin {
  static LoggerService get logger =>
      LittleFishCore.instance.get<LoggerService>();

  StoreProduct({
    this.id,
    this.averageRating,
    this.barcode,
    this.baseCategory,
    this.businessId,
    this.compareAtPrice,
    this.costPrice,
    this.createdBy,
    this.dateCreated,
    this.dateUpdated,
    this.description,
    this.displayName,
    this.featureImageUrl,
    this.featureVideoUrl,
    this.gallery,
    this.inStock,
    this.isFeatured,
    this.manageStock,
    this.name,
    this.onSale,
    this.productId,
    this.productLink,
    this.ratingCount,
    this.searchName,
    this.sellingPrice,
    this.sku,
    this.subCategories,
    this.updatedBy,
    this.relatedProducts,
    this.deleted,
    this.isNew,
    this.currencyCode,
    this.shortCurrencyCode,
    this.countryCode,
    this.productSettings,
    this.storeProductVariantType,
    this.productVariant,
  });

  //id and product id are the same value
  String? id;

  String? businessId;

  String? currencyCode;

  String? shortCurrencyCode;

  String? countryCode;

  @JsonKey(defaultValue: StoreProductVariantType.standalone)
  StoreProductVariantType? storeProductVariantType;

  ProductVariant? productVariant;

  String? productId;

  String? baseCategory, baseCategoryId;

  DateTime? dateCreated, dateUpdated;

  String? createdBy, updatedBy;

  String? name;

  String? displayName;

  String? searchName;

  String? description;

  String? productLink;

  //default this for UI interactions
  @JsonKey(defaultValue: 0.00)
  double? costPrice, compareAtPrice, sellingPrice;

  String? sku;

  String? barcode;

  @JsonKey(defaultValue: false)
  bool? inStock, onSale, manageStock;

  @JsonKey(defaultValue: false)
  bool? deleted;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  int? ratingCount;

  double? averageRating;

  String? featureImageUrl, featureImageAddress;

  String? featureVideoUrl;

  StoreProductSettings? productSettings;

  @JsonKey(defaultValue: false)
  bool? isFeatured;

  @JsonKey(defaultValue: <String>[])
  List<String>? subCategories;

  @JsonKey(defaultValue: <String>[])
  List<String>? gallery;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get hasGallery {
    if (gallery == null || gallery!.isEmpty) return false;
    return true;
  }

  bool get formComplete =>
      isNotBlank(displayName) &&
      (costPrice != null && costPrice != 0) &&
      (sellingPrice != null && sellingPrice != 0);

  @JsonKey(defaultValue: <StoreRelatedProduct>[])
  List<StoreRelatedProduct>? relatedProducts;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get hasRatings {
    if (ratingCount == null || ratingCount! <= 0) return false;
    return true;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get reviewsCollection =>
      documentReference?.collection('reviews');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get priceListsCollection =>
      documentReference?.collection('price_lists');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get attributesCollection =>
      documentReference?.collection('attributes');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get tagsCollection =>
      documentReference?.collection('tags');

  Future<void> saveAttribute(StoreProductAttribute item) async {
    await attributesCollection!
        .doc(item.id)
        .set(item.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteAttribute(StoreProductAttribute item) async {
    await attributesCollection!.doc(item.id).delete();
  }

  factory StoreProduct.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreProductFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory StoreProduct.fromJson(Map<String, dynamic> json) =>
      _$StoreProductFromJson(json)..isNew = false;

  Map<String, dynamic> toJson() => _$StoreProductToJson(this);

  StoreProduct.create(String this.businessId) {
    manageStock = false;
    averageRating = 0;
    ratingCount = 0;
    inStock = true;
    isFeatured = false;
    onSale = false;
    gallery = <String>[];
    deleted = false;
    isNew = true;
    relatedProducts = <StoreRelatedProduct>[];
    id = productId = const Uuid().v4();
    productSettings = StoreProductSettings.defaults();
    storeProductVariantType = StoreProductVariantType.standalone;
  }

  factory StoreProduct.fromProduct(StoreProduct prod) => StoreProduct(
    averageRating: prod.averageRating,
    baseCategory: prod.baseCategory,
  )..baseCategoryId = prod.baseCategoryId;
}

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class StoreRelatedProduct {
  StoreRelatedProduct({this.featureImageUrl, this.productId, this.productName});

  String? productId;

  String? featureImageUrl;

  String? productName;

  factory StoreRelatedProduct.fromJson(Map<String, dynamic> json) =>
      _$StoreRelatedProductFromJson(json);

  Map<String, dynamic> toJson() => _$StoreRelatedProductToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoreProductAttribute extends FirebaseDocumentModel {
  StoreProductAttribute({this.id, this.name, this.option});

  String? id;

  String? name;

  String? option;

  factory StoreProductAttribute.fromJson(Map<String, dynamic> json) =>
      _$StoreProductAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductAttributeToJson(this);

  factory StoreProductAttribute.create() =>
      StoreProductAttribute(id: const Uuid().v4(), option: '', name: '');
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoreProductTag {
  StoreProductTag({this.id, this.tag});

  String? id;

  String? tag;

  factory StoreProductTag.fromJson(Map<String, dynamic> json) =>
      _$StoreProductTagFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductTagToJson(this);

  factory StoreProductTag.create() =>
      StoreProductTag(id: const Uuid().v4(), tag: '');
}

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class StoreProductCategory extends FirebaseDocumentModel {
  StoreProductCategory({
    this.businessId,
    this.categoryId,
    this.createdBy,
    this.dateCreated,
    this.dateUpdated,
    this.description,
    this.displayName,
    this.featureImageUrl,
    this.name,
    this.searchName,
    this.updatedBy,
    this.id,
    this.productCount,
    this.storeSubtypeId,
    this.productTypeCount,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  String? businessId;

  //category id and id are the same value
  String? categoryId, id;

  String? name;

  String? displayName;

  String? searchName;

  String? storeSubtypeId;

  String? description;

  String? featureImageUrl;

  @JsonKey(defaultValue: 0)
  int? productCount;

  @JsonKey(defaultValue: 0)
  int? productTypeCount;

  DateTime? dateCreated, dateUpdated;

  @JsonKey(defaultValue: false)
  bool? deleted;

  String? createdBy, updatedBy;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StoreProductCategory>? subCategories;

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get subCategoriesCollection =>
      documentReference?.collection('categories');

  Future<bool> populateSubCategories() async {
    //the trigger will populate this on the backend - do not change
    if ((productTypeCount ?? 0) <= 0) return true;

    try {
      var subs = (await subCategoriesCollection!.get()).docs
          .map(
            (e) =>
                StoreProductCategory.fromJson(e.data() as Map<String, dynamic>)
                  ..documentSnapshot = e
                  ..documentReference = e.reference
                  ..populateSubCategories(),
          )
          .toList();

      subCategories = subs;
      LittleFishCore.instance.get<LoggerService>().debug(
        'features.ecommerce.store_product',
        'Successfully loaded sub categories',
      );
    } catch (error) {
      LittleFishCore.instance.get<LoggerService>().error(
        'features.ecommerce.store_product',
        'Failed to load sub categories: $error',
      );
      // reportCheckedError(error);
      return false;
    }

    return true;
  }

  StoreProductCategory.create(String this.businessId) {
    categoryId = id = const Uuid().v4();
    isNew = true;
    dateUpdated = dateCreated = DateTime.now();
    deleted = false;
    productCount = 0;
    productTypeCount = 0;
  }

  factory StoreProductCategory.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreProductCategoryFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory StoreProductCategory.fromJson(Map<String, dynamic> json) =>
      _$StoreProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductCategoryToJson(this);
}

@DateTimeConverter()
@JsonSerializable(explicitToJson: true)
class StoreProductRating {
  StoreProductRating({
    this.businessId,
    this.comments,
    this.rating,
    this.review,
    this.reviewDate,
    this.userId,
    this.userName,
    this.productId,
    this.displayName,
  });

  StoreProductRating.fromProduct(
    StoreProduct product, {
    this.userId,
    this.userName,
    String? displayName,
  }) {
    productId = product.id;
    businessId = product.businessId;
    rating = 0;
    review = '';
    reviewDate = DateTime.now();
  }

  String? get id => productId;

  String? productId;

  String? businessId;

  double? rating;

  String? review;

  DateTime? reviewDate;

  String? userId;

  String? userName;

  String? displayName;

  @JsonKey(defaultValue: [], includeFromJson: true, includeToJson: true)
  List<StoreProductRatingComment>? comments;

  factory StoreProductRating.fromJson(Map<String, dynamic> json) =>
      _$StoreProductRatingFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductRatingToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreProductRatingComment {
  StoreProductRatingComment({
    this.comment,
    this.commentDate,
    this.userId,
    this.userName,
    this.comments,
  });

  String? comment;

  String? userId;

  String? userName;

  DateTime? commentDate;

  @JsonKey(defaultValue: [], includeFromJson: true, includeToJson: true)
  List<StoreProductRatingComment>? comments;

  factory StoreProductRatingComment.fromJson(Map<String, dynamic> json) =>
      _$StoreProductRatingCommentFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductRatingCommentToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreProductSettings {
  StoreProductSettings({
    this.allowComments,
    this.allowReview,
    this.allowWishList,
    this.showInStock,
    this.trackViews,
  });

  StoreProductSettings.defaults() {
    allowReview = true;
    allowComments = false;
    showInStock = false;
    allowWishList = true;
    trackViews = true;
  }

  @JsonKey(defaultValue: true)
  bool? allowReview;

  @JsonKey(defaultValue: false)
  bool? allowComments;

  @JsonKey(defaultValue: false)
  bool? showInStock;

  @JsonKey(defaultValue: true)
  bool? allowWishList;

  @JsonKey(defaultValue: true)
  bool? trackViews;

  factory StoreProductSettings.fromJson(Map<String, dynamic> json) =>
      _$StoreProductSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductSettingsToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class PriceList extends FirebaseDocumentModel {
  DateTime? dateCreated;
  String? id, name, displayName, searchName, description;
  bool? deleted;
  double? sellingPrice, costPrice, compareAtPrice;

  @JsonKey(defaultValue: 0)
  int? totalProducts;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late List<PriceListLink> selectedProducts;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StoreProduct>? products;

  PriceList({
    this.id,
    this.name,
    this.displayName,
    this.dateCreated,
    this.description,
    this.searchName,
    this.totalProducts,
    this.deleted,
    this.compareAtPrice,
    this.costPrice,
    this.sellingPrice,
  });

  PriceList.defaults() {
    selectedProducts = <PriceListLink>[];
    totalProducts = 0;
    dateCreated = DateTime.now();
    deleted = false;
    id = const Uuid().v4();
  }

  @override
  String toString() {
    return selectedProducts.join(', ');
  }

  factory PriceList.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$PriceListFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory PriceList.fromJson(Map<String, dynamic> json) =>
      _$PriceListFromJson(json);

  Map<String, dynamic> toJson() => _$PriceListToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get productListLinkCollection =>
      documentReference?.collection('product_links');
}

@JsonSerializable()
@IsoDateTimeConverter()
class PriceListLink extends FirebaseDocumentModel {
  String? productId, listId, displayName;
  DateTime? dateCreated;
  String? imageUrl;

  PriceListLink({
    this.productId,
    this.listId,
    this.displayName,
    this.dateCreated,
    this.imageUrl,
  });

  PriceListLink.fromProduct(StoreProduct product, String this.listId) {
    productId = product.productId;
    displayName = '${product.displayName}';
    dateCreated = DateTime.now();
    imageUrl = product.featureImageUrl;
  }

  factory PriceListLink.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$PriceListLinkFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory PriceListLink.fromJson(Map<String, dynamic> json) =>
      _$PriceListLinkFromJson(json);

  Map<String, dynamic> toJson() => _$PriceListLinkToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get priceListsCollection =>
      documentReference?.collection('price_lists');
}

@JsonSerializable()
@EpochDateTimeConverter()
class ProductVariant {
  List<VariantTitle>? variantTitles;
  List<ProductVariantLink>? variantCombinations;
  List<StoreProduct>? products;
  List<String>? totalCombinations;
  ProductVariantLink? selectedVariant;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StoreProduct>? fullProducts;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  ProductVariant({
    this.variantCombinations,
    this.variantTitles,
    this.products,
    this.totalCombinations,
    this.isNew,
    this.selectedVariant,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantToJson(this);
}

@JsonSerializable()
class VariantTitle {
  String? name;
  List<String>? values;

  VariantTitle({this.name, this.values});

  factory VariantTitle.fromJson(Map<String, dynamic> json) =>
      _$VariantTitleFromJson(json);

  Map<String, dynamic> toJson() => _$VariantTitleToJson(this);
}

@JsonSerializable()
class ProductVariantLink {
  String? variant;
  String? sku;
  String? productId;
  String? imageUrl;
  double? price;

  ProductVariantLink({
    this.price,
    this.productId,
    this.sku,
    this.variant,
    this.imageUrl,
  });

  factory ProductVariantLink.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantLinkFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantLinkToJson(this);
}

enum StoreProductVariantType { standalone, variant, child }

class StoreProductVariantTypeConverter
    implements JsonConverter<StoreProductVariantType?, String?> {
  const StoreProductVariantTypeConverter();

  @override
  StoreProductVariantType? fromJson(String? json) {
    return StoreProductVariantType.values.firstWhereOrNull(
      (element) => element.toString().split('.').last == json,
    );
  }

  @override
  String? toJson(StoreProductVariantType? object) {
    return object?.toString().split('.').last;
  }
}
