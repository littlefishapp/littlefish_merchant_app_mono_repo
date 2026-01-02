import 'package:cloud_firestore/cloud_firestore.dart';

import '../geo_flutter_fire_export.dart';

class Geoflutterfire {
  Geoflutterfire();

  GeoFireCollectionRef collection({
    required CollectionReference collectionRef,
  }) {
    return GeoFireCollectionRef(collectionRef);
  }

  GeoFirePoint point({required double latitude, required double longitude}) {
    return GeoFirePoint(latitude, longitude);
  }
}
