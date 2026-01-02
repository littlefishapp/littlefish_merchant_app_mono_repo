import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';

part 'store_subtype.g.dart';

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
class StoreSubtype extends FirebaseDocumentModel {
  String? storeType;
  String? name, displayName, description;
  String? icon;
  String? id;
  String? imageUrl;
  int? storeCount;
  int? productTypeCount;

  CollectionReference? get storeProductTypesCollection =>
      documentReference?.collection('store_product_types');

  CollectionReference? get storeAttributeGroupsCollection =>
      documentReference?.collection('store_attribute_groups');

  StoreSubtype({
    this.storeType,
    this.description,
    this.displayName,
    this.id,
    this.imageUrl,
    this.name,
    this.storeCount,
    this.productTypeCount,
    this.icon,
  });

  factory StoreSubtype.fromJson(Map<String, dynamic> json) =>
      _$StoreSubtypeFromJson(json);

  factory StoreSubtype.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreSubtypeFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  Map<String, dynamic> toJson() => _$StoreSubtypeToJson(this);
}

@JsonSerializable()
class StoreProductType extends FirebaseDocumentModel {
  String? name, displayName, description;
  String? subgroup;
  String? id;
  String? storeSubtypeId;
  int? storeCount;

  StoreProductType({
    this.description,
    this.displayName,
    this.id,
    this.storeSubtypeId,
    this.name,
    this.subgroup,
    this.storeCount,
  });

  factory StoreProductType.fromJson(Map<String, dynamic> json) =>
      _$StoreProductTypeFromJson(json);

  Map<String, dynamic> toJson() => _$StoreProductTypeToJson(this);
}

@JsonSerializable()
class StoreAttributeGroupLink extends FirebaseDocumentModel {
  String? id;
  String? storeSubtypeId;

  StoreAttributeGroupLink({this.id, this.storeSubtypeId});

  factory StoreAttributeGroupLink.fromJson(Map<String, dynamic> json) =>
      _$StoreAttributeGroupLinkFromJson(json);

  Map<String, dynamic> toJson() => _$StoreAttributeGroupLinkToJson(this);
}
