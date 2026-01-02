// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'payment_type.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class PaymentType with ChangeNotifier {
  PaymentType({
    this.enabled,
    this.id,
    this.name,
    this.displayIndex,
    this.provider,
    this.paid,
    this.providerPaymentReference,
    this.icon,
    this.imageURI,
  });

  bool get isCash => name?.toLowerCase() == 'cash';

  bool get isCard => name?.toLowerCase() == 'card';

  bool get isSnapscan => name?.toLowerCase().contains('snapscan') ?? false;

  bool get isZapper => name?.toLowerCase().contains('zapper') ?? false;

  bool get isOther => name?.toLowerCase().contains('other') ?? false;

  bool get hasImage => imageURI != null && (imageURI?.isNotEmpty ?? false);

  IconData get iconData {
    if (icon != null) return icon!;

    if (isCash) return Icons.local_atm_outlined;

    if (isCard) return Icons.payment;

    if (isSnapscan) return Icons.qr_code;

    if (isZapper) return Icons.qr_code;

    if (isOther) return Icons.payment;

    return Icons.payment;
  }

  bool get isQR => isZapper || isSnapscan;

  String? id, name, providerPaymentReference;

  bool? enabled, paid;

  PaymentProvider? provider;

  @JsonKey(defaultValue: 0)
  int? displayIndex;

  @JsonKey(includeFromJson: false, includeToJson: false)
  IconData? icon;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? imageURI;

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTypeToJson(this);

  PaymentType.clone(PaymentType paymentType)
    : id = paymentType.id,
      name = paymentType.name,
      enabled = paymentType.enabled,
      paid = paymentType.paid,
      provider = paymentType.provider,
      displayIndex = paymentType.displayIndex,
      providerPaymentReference = paymentType.providerPaymentReference,
      icon = paymentType.icon,
      imageURI = paymentType.imageURI;
}

enum PaymentProvider {
  @JsonValue(0)
  none,
  @JsonValue(1)
  zapper,
  @JsonValue(2)
  snapscan,
}
