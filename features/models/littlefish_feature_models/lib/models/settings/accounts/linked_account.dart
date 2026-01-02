// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';

import 'package:littlefish_payments/models/accounts/linked_account.dart' as pm;

part 'linked_account.g.dart';

@JsonSerializable()
class LinkedAccount {
  ProviderType? providerType;
  String? providerName;
  String? id;
  String? imageURI;
  bool? hasQRCode;
  bool? isQRCodeEnabled;
  String? config;
  LinkedAccountType? linkedAccountType;
  bool? enabled;
  bool? deleted;
  DateTime? dateUpdated;
  String? updatedBy;
  DateTime? dateCreated;
  String? createdBy;

  LinkedAccount({
    this.config,
    this.deleted,
    this.createdBy,
    this.dateCreated,
    this.updatedBy,
    this.dateUpdated,
    this.providerName,
    this.id,
    this.enabled,
    this.providerType,
    this.imageURI,
    this.hasQRCode,
    this.isQRCodeEnabled,
    this.linkedAccountType,
  });

  LinkedAccount.fromProvider(pm.LinkedAccount account)
    : providerType = LinkedAccountUtils.getProviderType(account.providerType),
      providerName = account.providerName,
      id = account.id,
      imageURI = account.imageURI,
      hasQRCode = account.hasQRCode,
      isQRCodeEnabled = account.isQRCodeEnabled,
      config = account.config,
      linkedAccountType = LinkedAccountUtils.getLinkedAccountType(
        account.linkedAccountType,
      ),
      enabled = account.enabled,
      deleted = account.deleted,
      dateUpdated = account.dateUpdated,
      updatedBy = account.updatedBy,
      dateCreated = account.dateCreated,
      createdBy = account.createdBy;

  factory LinkedAccount.fromJson(Map<String, dynamic> json) =>
      _$LinkedAccountFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedAccountToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class SalesChannel {
  String? channelName;
  String? id, storeId;
  String? config;
  bool? deleted;
  String? updatedBy, createdBy;
  DateTime? dateUpdated, dateCreated;
  SalesChannelType? salesChannelType;
  String? imageUri;

  @JsonKey(defaultValue: true)
  bool? syncItems;

  SalesChannel({
    this.salesChannelType,
    this.config,
    this.createdBy,
    this.dateCreated,
    this.channelName,
    this.dateUpdated,
    this.deleted,
    this.id,
    this.storeId,
    this.syncItems,
    this.updatedBy,
    this.imageUri,
  });

  factory SalesChannel.fromJson(Map<String, dynamic> json) =>
      _$SalesChannelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesChannelToJson(this);
}

enum SalesChannelType {
  @JsonValue(0)
  littleFishEcommerce,
}

enum LinkedAccountType {
  @JsonValue(0)
  payment,
}

enum ProviderType {
  @JsonValue(0)
  zapper,
  @JsonValue(1)
  snapscan,
  @JsonValue(2)
  cRDB,
  @JsonValue(3)
  kYC,
  @JsonValue(4)
  pos,
  @JsonValue(5)
  cybersourceTapToPay,
  @JsonValue(6)
  wizzitTapToPay,
  @JsonValue(7)
  fnbECom,
}
