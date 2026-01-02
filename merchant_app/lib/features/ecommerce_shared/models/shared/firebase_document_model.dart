import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class FirebaseDocumentModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentSnapshot? documentSnapshot;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentReference? _reference;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentReference? get documentReference {
    if (_reference == null && hasDocument) {
      _reference = documentSnapshot!.reference;
    }

    return _reference;
  }

  set documentReference(DocumentReference? value) => _reference = value;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get hasReference => documentReference != null;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get hasDocument => documentSnapshot != null;
}

mixin FirebaseDocumentMixin {
  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentSnapshot? documentSnapshot;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentReference? _reference;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DocumentReference? get documentReference {
    if (_reference == null && hasDocument) {
      _reference = documentSnapshot!.reference;
    }

    return _reference;
  }

  set documentReference(DocumentReference? value) => _reference = value;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get hasReference => documentReference != null;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get hasDocument => documentSnapshot != null;
}
