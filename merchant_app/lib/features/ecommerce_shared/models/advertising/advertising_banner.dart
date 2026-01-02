class AdvertisingBanner {
  AdvertisingBanner({
    this.description,
    this.enabled,
    this.endDate,
    this.id,
    this.name,
    this.startDate,
    this.uri,
  });

  String? id;

  String? name;

  String? description;

  bool? enabled;

  DateTime? startDate;

  DateTime? endDate;

  String? uri;
}
