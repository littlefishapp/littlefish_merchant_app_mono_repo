import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../shared/firebase_document_model.dart';
import 'store.dart';

part 'store_preferences.g.dart';

@JsonSerializable(explicitToJson: true)
class StorePreferences extends FirebaseDocumentModel {
  StorePreferences({
    this.acceptsOnlineOrders = false,
    this.allowGuestCheckout = false,
    this.layoutTemplate,
    this.showOutOfStock = false,
    this.theme,
    this.allowProductRating = false,
    this.allowStoreRating = false,
    this.onlineFee,
    this.freeDelivery,
    this.paymentTypes,
    this.acceptCOD = true,
  });

  StoreTheme? theme;
  FreeDelivery? freeDelivery;
  OnlineFee? onlineFee;
  String? paymentTypes;
  String? layoutTemplate;
  bool? acceptsOnlineOrders;
  bool acceptCOD;
  bool? showOutOfStock;
  bool allowProductRating;
  bool allowStoreRating;
  bool? allowGuestCheckout;

  factory StorePreferences.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) {
    var reference = FirebaseFirestore.instance
        .collection('stores')
        .doc('storeid');

    reference.collection('banners');

    reference.collection('products');

    reference.collection('customers');

    reference.collection('ratings');

    return _$StorePreferencesFromJson(snapshot.data() as Map<String, dynamic>)
      ..documentSnapshot = snapshot
      ..documentReference = reference;
  }

  factory StorePreferences.fromJson(Map<String, dynamic> json) =>
      _$StorePreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$StorePreferencesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StoreTheme {
  StoreTheme({
    this.primaryColor,
    this.secondaryColor,
    this.primaryFont,
    this.layout,
  });

  String? primaryColor;

  String? secondaryColor;

  String? primaryFont;

  String? layout;

  factory StoreTheme.fromJson(Map<String, dynamic> json) =>
      _$StoreThemeFromJson(json);

  Map<String, dynamic> toJson() => _$StoreThemeToJson(this);
}
