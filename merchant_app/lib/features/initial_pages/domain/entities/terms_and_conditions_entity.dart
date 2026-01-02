// lib/features/initial_pages/domain/entities/terms_and_conditions_entity.dart
import 'package:equatable/equatable.dart';

class TermsAndConditionsEntity extends Equatable {
  final bool inverseColour;
  final List<String> prefixTexts; // e.g. ["By signing in, I agree to the "]
  final String linkText; // e.g. "T&Cs"
  final String url; // URL or asset path
  final String title; // Screen title
  final bool isAsset; // true → asset, false → network

  const TermsAndConditionsEntity({
    this.inverseColour = false,
    this.prefixTexts = const [],
    this.linkText = '',
    this.url = '',
    this.title = '',
    this.isAsset = false,
  });

  @override
  List<Object?> get props => [
    inverseColour,
    prefixTexts,
    linkText,
    url,
    title,
    isAsset,
  ];

  TermsAndConditionsEntity copyWith({
    bool? inverseColour,
    List<String>? prefixTexts,
    String? linkText,
    String? url,
    String? title,
    bool? isAsset,
  }) {
    return TermsAndConditionsEntity(
      inverseColour: inverseColour ?? this.inverseColour,
      prefixTexts: prefixTexts ?? this.prefixTexts,
      linkText: linkText ?? this.linkText,
      url: url ?? this.url,
      title: title ?? this.title,
      isAsset: isAsset ?? this.isAsset,
    );
  }
}
