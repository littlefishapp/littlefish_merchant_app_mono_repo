import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../shared/firebase_document_model.dart';

part 'store_type.g.dart';

@JsonSerializable()
class StoreType extends FirebaseDocumentModel {
  String? id, name, displayName, description;
  int? storeCount;
  String? imageUrl;

  CollectionReference? get storeSubtypesCollection =>
      documentReference?.collection('store_subtypes');

  StoreType({
    this.id,
    this.description,
    this.displayName,
    this.imageUrl,
    this.name,
    this.storeCount,
  });

  factory StoreType.fromJson(Map<String, dynamic> json) =>
      _$StoreTypeFromJson(json);

  factory StoreType.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreTypeFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  Map<String, dynamic> toJson() => _$StoreTypeToJson(this);
}
