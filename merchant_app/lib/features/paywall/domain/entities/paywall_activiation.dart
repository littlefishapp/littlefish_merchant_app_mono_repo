import 'package:equatable/equatable.dart';

class PaywallActivation extends Equatable {
  final String title;
  final String summaryText;
  final String pricingInformation;
  final String termsUrl;
  final String termsLinkText;
  final String activationType;
  final String tapDescriptionText;

  const PaywallActivation({
    this.title = '',
    this.summaryText = '',
    this.pricingInformation = '',
    this.termsUrl = '',
    this.termsLinkText = '',
    this.activationType = '',
    this.tapDescriptionText = '',
  });

  PaywallActivation copyWith({
    String? title,
    String? summaryText,
    String? pricingInformation,
    String? termsUrl,
    String? termsLinkText,
    String? activationType,
    String? tapDescriptionText,
  }) {
    return PaywallActivation(
      title: title ?? this.title,
      summaryText: summaryText ?? this.summaryText,
      pricingInformation: pricingInformation ?? this.pricingInformation,
      termsUrl: termsUrl ?? this.termsUrl,
      termsLinkText: termsLinkText ?? this.termsLinkText,
      activationType: activationType ?? this.activationType,
      tapDescriptionText: tapDescriptionText ?? this.tapDescriptionText,
    );
  }

  @override
  List<Object?> get props => [
    title,
    summaryText,
    pricingInformation,
    termsUrl,
    termsLinkText,
    activationType,
    tapDescriptionText,
  ];
}
