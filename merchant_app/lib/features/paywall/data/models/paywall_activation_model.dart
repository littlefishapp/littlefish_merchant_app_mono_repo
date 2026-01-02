import 'dart:convert';
import 'package:littlefish_merchant/features/paywall/domain/entities/paywall_activiation.dart';

class PaywallActivationModel {
  PaywallActivation fromJson(Map<String, dynamic> json) {
    return PaywallActivation(
      title: json['title'] ?? '',
      summaryText: json['summary_text'] ?? '',
      pricingInformation: json['pricing_information'] ?? '',
      termsUrl: json['terms_url'] ?? '',
      termsLinkText: json['terms_link_text'] ?? '',
      activationType: json['activation_type'] ?? '',
      tapDescriptionText: json['tap_description_text'] ?? '',
    );
  }

  PaywallActivation fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return fromJson(jsonMap);
  }

  Map<String, dynamic> toJson(PaywallActivation instance) {
    return {
      'title': instance.title,
      'summary_text': instance.summaryText,
      'pricing_information': instance.pricingInformation,
      'terms_url': instance.termsUrl,
      'terms_link_text': instance.termsLinkText,
      'activation_type': instance.activationType,
      'tap_description_text': instance.tapDescriptionText,
    };
  }
}
