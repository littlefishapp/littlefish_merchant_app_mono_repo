// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/shared/data/contact.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';
import 'package:littlefish_merchant/models/store/receipt_data.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'business_profile.g.dart';

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class BusinessProfile with ChangeNotifier {
  BusinessProfile({
    this.category,
    this.description,
    this.id,
    this.name,
    this.parentId,
    this.type,
    this.countryCode,
    this.values,
    this.address,
    this.receiptData,
    this.contacts,
    this.contactDetails,
    this.logoUri,
    this.linkedAccounts,
    this.taxNumber,
    this.tradingTime,
    this.dateEstablished,
    this.coverUri,
    this.phoneNumber,
    this.businessEmail,
    this.whatsappLine,
    this.website,
    this.instagramHandle,
    this.facebook,
    this.twitter,
    this.salesChannels,
    this.storeCreditSettings,
    this.registrationNumber,
    this.masterMerchantId,
    this.mcc,
    this.vatEnabled,
    this.vatBillingAddress,
  });

  BusinessProfile.create() {
    id = const Uuid().v4();
    contactDetails = ContactDetail();
    contacts = <Contact>[];
    address = Address();
    vatBillingAddress = Address();
    receiptData = ReceiptData();
  }

  String? id, parentId, name, description;

  String? countryCode;

  BusinessType? type, category;

  Map<String, dynamic>? values;

  Address? address;

  Address? vatBillingAddress;

  String? whatsappLine;

  String? instagramHandle;

  StoreCreditSettings? storeCreditSettings;

  String? logoUri;

  String? businessEmail;

  String? facebook, twitter;

  String? phoneNumber;
  String? website;

  String? masterMerchantId;

  String? taxNumber;

  bool? vatEnabled;

  String? mcc;

  String? registrationNumber;

  ReceiptData? receiptData;

  @JsonKey(name: 'contactDetail')
  ContactDetail? contactDetails;

  TradingTime? tradingTime;
  String? coverUri;
  DateTime? dateEstablished;

  List<LinkedAccount>? linkedAccounts;

  List<SalesChannel>? salesChannels;

  @JsonKey(defaultValue: <Contact>[])
  List<Contact>? contacts;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessProfileToJson(this);

  bool validate() {
    return name != null && type != null;
  }
}

@JsonSerializable()
class TradingHours {
  String? open;
  String? close;

  TradingHours({this.open, this.close});

  factory TradingHours.fromJson(Map<String, dynamic> json) =>
      _$TradingHoursFromJson(json);

  Map<String, dynamic> toJson() => _$TradingHoursToJson(this);
}

@JsonSerializable()
class TradingTime {
  TradingHours? weekday;
  TradingHours? saturday;
  TradingHours? sunday;
  TradingHours? publicHoliday;

  TradingTime({this.publicHoliday, this.saturday, this.sunday, this.weekday});

  factory TradingTime.fromJson(Map<String, dynamic> json) =>
      _$TradingTimeFromJson(json);

  Map<String, dynamic> toJson() => _$TradingTimeToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class StoreCreditSettings {
  bool? enabled, enableInterest;

  DateTime? dateUpdated;

  String? repaymentPeriod, businessId, updatedBy;

  double? interestRate, creditLimit;

  StoreCreditSettings({
    this.businessId,
    this.creditLimit,
    this.dateUpdated,
    this.enabled,
    this.interestRate,
    this.repaymentPeriod,
    this.updatedBy,
    this.enableInterest,
  });

  factory StoreCreditSettings.fromJson(Map<String, dynamic> json) =>
      _$StoreCreditSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCreditSettingsToJson(this);
}
