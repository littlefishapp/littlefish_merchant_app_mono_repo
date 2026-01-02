import 'package:json_annotation/json_annotation.dart';

import '../shared/firebase_document_model.dart';
part 'store_banner.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreBanner extends FirebaseDocumentModel {
  String? bannerUrl, bannerMessage;
  bool? enabled;
  DateTime? startDate;
  DateTime? endDate;

  StoreBanner({
    this.bannerMessage,
    this.bannerUrl,
    this.enabled,
    this.endDate,
    this.startDate,
  });

  factory StoreBanner.fromJson(Map<String, dynamic> json) =>
      _$StoreBannerFromJson(json);

  Map<String, dynamic> toJson() => _$StoreBannerToJson(this);
}
