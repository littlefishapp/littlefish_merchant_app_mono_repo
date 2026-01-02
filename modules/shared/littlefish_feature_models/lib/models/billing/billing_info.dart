// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'billing_info.g.dart';

@JsonSerializable()
@EpochDateTimeConverter()
class BillingStoreInfo {
  BillingStoreInfo({
    this.app,
    this.businessId,
    this.businessName,
    this.country,
    this.lastPaymentAmount,
    this.lastPaymentDate,
    this.currentLicense,
    this.isPaid,
    this.lastCheckedDate,
    this.overrideSubscription = false,
    this.syncedToRevenueCat = false,
    this.validUntil,
    this.duration,
  });

  String? businessId, businessName, country;
  DateTime? lastPaymentDate, lastCheckedDate, validUntil;
  double? lastPaymentAmount;
  String? app, currentLicense;
  bool? isPaid, overrideSubscription, syncedToRevenueCat;
  SubscriptionDuration? duration;

  BillingStoreInfo.create(
    this.businessId,
    this.businessName,
    String this.country,
  ) {
    app = 'littlefish_pos';
    currentLicense = 'free';
    lastPaymentAmount = 0;
    isPaid = false;
    overrideSubscription = false;
  }

  factory BillingStoreInfo.fromJson(Map<String, dynamic> json) =>
      _$BillingStoreInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BillingStoreInfoToJson(this);
}

@JsonSerializable()
@EpochDateTimeConverter()
class BillingPaymentEntry {
  BillingPaymentEntry({
    this.app,
    this.businessId,
    this.businessName,
    this.country,
    this.amount,
    this.paymentDate,
    this.currentLicense,
    this.paidBy,
    this.duration,
    this.isTrial,
  });

  String? businessId, businessName, country, paidBy;
  DateTime? paymentDate;
  double? amount;
  String? app, currentLicense;
  SubscriptionDuration? duration;
  bool? isTrial;

  factory BillingPaymentEntry.fromJson(Map<String, dynamic> json) =>
      _$BillingPaymentEntryFromJson(json);

  Map<String, dynamic> toJson() => _$BillingPaymentEntryToJson(this);
}

enum SubscriptionDuration {
  @JsonValue('month')
  month,
  @JsonValue('year')
  year,
}
