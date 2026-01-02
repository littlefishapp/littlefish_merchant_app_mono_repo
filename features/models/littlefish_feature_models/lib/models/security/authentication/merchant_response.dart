// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';

import 'generate_otp_request.dart';

part 'merchant_response.g.dart';

@JsonSerializable()
class MerchantResponse {
  MerchantResponse({required this.baseResponse, this.otpInformation});

  ApiBaseResponse baseResponse;
  List<GenerateOTPRequest>? otpInformation;

  factory MerchantResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantResponseToJson(this);
}
