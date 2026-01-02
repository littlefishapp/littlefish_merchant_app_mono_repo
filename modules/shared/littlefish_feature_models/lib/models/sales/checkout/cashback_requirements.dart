import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements.dart';

part 'cashback_requirements.g.dart';

@JsonSerializable()
class CashbackRequirements extends CheckoutActionRequirements {
  CashbackRequirements({
    double? minAmount,
    double? maxAmount,
    bool isRequired = false,
  }) : super(
         minAmount: minAmount,
         maxAmount: maxAmount,
         isRequired: isRequired,
       );

  factory CashbackRequirements.fromJson(Map<String, dynamic> json) =>
      _$CashbackRequirementsFromJson(json);

  Map<String, dynamic> toJson() => _$CashbackRequirementsToJson(this);
}
