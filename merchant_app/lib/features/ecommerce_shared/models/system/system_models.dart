import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';

import '../shared/firebase_document_model.dart';

part 'system_models.g.dart';

@JsonSerializable()
class SystemGalleryItem extends FirebaseDocumentModel {
  SystemGalleryItem({
    this.businessId,
    this.createdBy,
    this.dateCreated,
    this.id,
    this.isDeleted,
    this.isRemoved,
    this.itemAddress,
    this.itemUrl,
    this.type,
  });

  String? id;

  String? businessId;

  String? type;

  DateTime? dateCreated;

  String? itemUrl;

  String? itemAddress;

  bool? isDeleted;

  bool? isRemoved;

  String? createdBy;

  factory SystemGalleryItem.fromJson(Map<String, dynamic> json) =>
      _$SystemGalleryItemFromJson(json);

  Map<String, dynamic> toJson() => _$SystemGalleryItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SystemCountryConfig extends FirebaseDocumentModel {
  SystemCountryConfig({this.countryCode, this.enabled, this.name});

  String? countryCode;

  @JsonKey(defaultValue: false)
  bool? enabled;

  @JsonKey(defaultValue: false)
  bool? financeMarketActive;

  String? name;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<SystemPaymentType>? _paymentTypes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<SystemCreditProvider>? _creditProviders;

  SystemCreditProvider? getCreditProviderByOption(String option) {
    return _creditProviders?.firstWhereOrNull(
      (element) => element.options!.contains(option),
    );
  }

  List<WalletProvider>? _walletProviders;

  CollectionReference? get paymentTypesCollection =>
      documentReference?.collection('payment_types');

  CollectionReference? get financeProvidersCollection =>
      documentReference?.collection('finance_providers');

  Future<List<SystemCreditProvider>?> get creditProviders async {
    if (_creditProviders == null || _creditProviders!.isEmpty) {
      _creditProviders = await getCreditProviders();

      return _creditProviders;
    } else {
      return _creditProviders;
    }
  }

  Future<List<SystemCreditProvider>> getCreditProviders() async {
    var values =
        (await financeProvidersCollection!
                .where('enabled', isEqualTo: true)
                .get())
            .docs
            .map(
              (e) => SystemCreditProvider.fromJson(
                e.data() as Map<String, dynamic>,
              )..documentReference = e.reference,
            )
            .toList();

    return values;
  }

  CollectionReference? get walletProvidersCollection =>
      documentReference?.collection('wallet_providers');

  //this will be linked to a future builder when required or needed
  Future<List<SystemPaymentType>?> get paymentTypes async {
    if (_paymentTypes == null || _paymentTypes!.isEmpty) {
      _paymentTypes = await getPaymentTypes();

      return _paymentTypes;
    } else {
      return _paymentTypes;
    }
  }

  //this will be linked to a future builder when required or needed
  Future<List<WalletProvider>?> get walletProviders async {
    if (_walletProviders == null || _walletProviders!.isEmpty) {
      _walletProviders = await getWalletProviders();

      return _walletProviders;
    } else {
      return _walletProviders;
    }
  }

  Future<List<SystemPaymentType>> getPaymentTypes() async {
    var types =
        (await paymentTypesCollection!.where('enabled', isEqualTo: true).get())
            .docs
            .map(
              (e) =>
                  SystemPaymentType.fromJson(e.data() as Map<String, dynamic>)
                    ..documentReference = e.reference,
            )
            .toList();

    return types;
  }

  Future<List<WalletProvider>> getWalletProviders() async {
    var types =
        (await walletProvidersCollection!
                .where('enabled', isEqualTo: true)
                .get())
            .docs
            .map(
              (e) =>
                  WalletProvider.fromJson(e.data() as Map<String, dynamic>)
                    ..documentReference = e.reference,
            )
            .toList();

    return types;
  }

  factory SystemCountryConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemCountryConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SystemCountryConfigToJson(this);
}

@JsonSerializable()
class SystemCreditProvider extends FirebaseDocumentModel {
  @JsonKey(defaultValue: true)
  bool? enabled;

  @JsonKey(defaultValue: [])
  List<String>? options;

  String? name;

  Map<String, dynamic>? config;

  SystemCreditProvider({this.config, this.enabled, this.name, this.options});

  factory SystemCreditProvider.fromJson(Map<String, dynamic> json) =>
      _$SystemCreditProviderFromJson(json);

  Map<String, dynamic> toJson() => _$SystemCreditProviderToJson(this);
}

@JsonSerializable()
class SystemPaymentType extends FirebaseDocumentModel {
  SystemPaymentType({
    this.config,
    this.displayName,
    this.enabled,
    this.name,
    this.type,
    this.logoUrl,
    this.fee,
    this.feeLimit,
    this.feeType,
    this.options,
  });

  bool? enabled;

  String? name;

  @JsonKey(defaultValue: <String>[])
  List<String>? options;

  String? displayName;

  @JsonKey(defaultValue: 'fixed')
  String? feeType;

  @JsonKey(defaultValue: 0)
  double? fee;

  @JsonKey(defaultValue: 0)
  double? feeLimit;

  String? type;

  String? logoUrl;

  Map<String, dynamic>? config;

  double? calculateFee(double transactionAmount) {
    if (transactionAmount <= 0) return 0.0;

    if (fee! <= 0) return fee;

    if (feeType == 'fixed') return fee;

    var percentageValue = fee! / 100;

    var feeValue = transactionAmount * percentageValue;

    if (feeLimit! <= 0) return feeValue;

    if (feeValue > feeLimit!) return feeLimit;

    return feeValue;
  }

  factory SystemPaymentType.fromJson(Map<String, dynamic> json) =>
      _$SystemPaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SystemPaymentTypeToJson(this);
}

@JsonSerializable()
class WalletProvider extends FirebaseDocumentModel {
  String? name, displayName, id;
  String? description;
  String? logoUrl;
  dynamic config;

  @JsonKey(defaultValue: true)
  bool? enabled;

  WalletProvider({
    this.name,
    this.displayName,
    this.description,
    this.config,
    this.logoUrl,
    this.enabled,
    this.id,
  });

  factory WalletProvider.fromJson(Map<String, dynamic> json) =>
      _$WalletProviderFromJson(json);

  Map<String, dynamic> toJson() => _$WalletProviderToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FirebaseIndex {
  String? collectionGroup;
  String? queryScope;
  List<FirebaseIndexField>? fields;

  FirebaseIndex({this.fields, this.queryScope, this.collectionGroup});

  factory FirebaseIndex.fromJson(Map<String, dynamic> json) =>
      _$FirebaseIndexFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseIndexToJson(this);
}

@JsonSerializable()
class FirebaseIndexField {
  String? fieldPath, order;

  FirebaseIndexField({this.fieldPath, this.order});

  factory FirebaseIndexField.fromJson(Map<String, dynamic> json) =>
      _$FirebaseIndexFieldFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseIndexFieldToJson(this);
}
