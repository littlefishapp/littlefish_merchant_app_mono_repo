import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';

part 'store_snapshot.g.dart';

@JsonSerializable()
class StoreSnapshot {
  String? id, storeId;
  String? name, displayName, description;
  String? storeTypeId;
  String? storeSubtypeId;
  String? coverImageUrl;
  String? logoUrl;
  StoreAddress? primaryAddress;

  StoreSnapshot({
    this.description,
    this.displayName,
    this.id,
    this.name,
    this.storeId,
    this.storeSubtypeId,
    this.storeTypeId,
    this.coverImageUrl,
    this.logoUrl,
    this.primaryAddress,
  });

  factory StoreSnapshot.fromJson(Map<String, dynamic> json) =>
      _$StoreSnapshotFromJson(json);

  factory StoreSnapshot.fromAgoliaResult(Map<String, dynamic> json) {
    json.remove('_geoloc');
    var location = json['primaryAddress'].remove('location');
    var res = StoreSnapshot.fromJson(json);

    if (location != null) {
      res.primaryAddress!.location = StoreLocation(
        hash: location['geohash'],
        latitude: location['geopoint']['_latitude'],
        longitude: location['geopoint']['_longitude'],
      );
    }

    return res;
  }

  Map<String, dynamic> toJson() => _$StoreSnapshotToJson(this);
}
