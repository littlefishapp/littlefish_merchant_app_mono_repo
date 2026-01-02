import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../shared/firebase_document_model.dart';

part 'store_attribute.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreAttributeGroup extends FirebaseDocumentModel {
  String? id, name, displayName, description;
  int? storeCount;
  String? imageUrl;

  CollectionReference? get storeAttributesCollection =>
      documentReference?.collection('store_attributes');

  StoreAttributeGroup({
    this.description,
    this.displayName,
    this.imageUrl,
    this.name,
    this.storeCount,
    this.id,
  });

  factory StoreAttributeGroup.fromJson(Map<String, dynamic> json) =>
      _$StoreAttributeGroupFromJson(json);

  factory StoreAttributeGroup.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreAttributeGroupFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  Map<String, dynamic> toJson() => _$StoreAttributeGroupToJson(this);
}

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
@StoreAttributeGroupSelectTypeConverter()
class StoreAttribute extends FirebaseDocumentModel {
  String? name, displayName, description;
  int? storeCount;
  String? imageUrl;
  StoreAttributeGroupSelectType? groupType;
  String? attributeGroup;
  String? id;

  StoreAttribute({
    this.attributeGroup,
    this.description,
    this.displayName,
    this.groupType,
    this.imageUrl,
    this.name,
    this.id,
    this.storeCount,
  });

  factory StoreAttribute.fromJson(Map<String, dynamic> json) =>
      _$StoreAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$StoreAttributeToJson(this);
}

enum StoreAttributeGroupSelectType { single, multiple }

class StoreAttributeGroupSelectTypeConverter
    implements JsonConverter<StoreAttributeGroupSelectType?, String> {
  const StoreAttributeGroupSelectTypeConverter();

  @override
  StoreAttributeGroupSelectType? fromJson(String? json) {
    return StoreAttributeGroupSelectType.values.firstWhereOrNull(
      (element) => element.toString().split('.').last == json,
    );
  }

  @override
  String toJson(StoreAttributeGroupSelectType? object) {
    return object.toString().split('.').last;
  }
}
