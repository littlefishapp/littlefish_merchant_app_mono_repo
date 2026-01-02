import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements.dart';

part 'withdraw_requirements.g.dart';

@JsonSerializable()
class WithdrawRequirements extends CheckoutActionRequirements {
  WithdrawRequirements({
    double? minAmount,
    double? maxAmount,
    bool isRequired = false,
  }) : super(
         minAmount: minAmount,
         maxAmount: maxAmount,
         isRequired: isRequired,
       );

  factory WithdrawRequirements.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRequirementsFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawRequirementsToJson(this);
}
