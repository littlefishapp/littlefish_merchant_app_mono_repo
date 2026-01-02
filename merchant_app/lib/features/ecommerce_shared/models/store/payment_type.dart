import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_type.g.dart';

@JsonSerializable()
@PaymentProviderConverter()
class PaymentType with ChangeNotifier {
  PaymentType({
    this.enabled,
    this.id,
    this.name,
    this.displayIndex,
    this.provider,
    this.paid,
    this.providerPaymentReference,
  });

  String? id, name, providerPaymentReference;

  bool? enabled, paid;

  PaymentProvider? provider;

  @JsonKey(defaultValue: 0)
  int? displayIndex;

  @JsonKey(includeFromJson: false, includeToJson: false)
  IconData? icon;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? imageURI;

  IconData get paymentTypeIcon {
    if (name == null) return Icons.more;

    // if (name.toLowerCase() == "cash") return MdiIcons.cash;

    // if (name.toLowerCase() == "card") return MdiIcons.creditCard;

    // if (name.toLowerCase() == "masterpass") return MdiIcons.creditCard;

    // if (name.toLowerCase() == "airtelmoney") return MdiIcons.cellphone;

    // if (name.toLowerCase() == "mpesa") return MdiIcons.cellphone;

    // if (name.toLowerCase() == "tigopesa") return MdiIcons.cellphone;

    // if (name.toLowerCase() == "zapper") return MdiIcons.qrcode;

    // if (name.toLowerCase() == "snapscan") return MdiIcons.qrcode;

    // if (name.toLowerCase() == "other") return MdiIcons.more;

    return Icons.more;
  }

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTypeToJson(this);
}

enum PaymentProvider { none, zapper, snapscan }

class PaymentProviderConverter implements JsonConverter<PaymentProvider, int> {
  const PaymentProviderConverter();

  @override
  PaymentProvider fromJson(int json) {
    return PaymentProvider.values[json];
  }

  @override
  int toJson(PaymentProvider object) {
    return object.index;
  }
}
