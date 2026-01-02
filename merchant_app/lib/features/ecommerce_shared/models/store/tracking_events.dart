class TrackingEvents {
  List<Tracking> trackings = [];

  TrackingEvents.fromJson(Map<String, dynamic> json) {
    final trackings = json['data']['trackings'];
    for (var item in trackings) {
      trackings.add(Tracking.fromJson(item));
    }
  }
}

class Tracking {
  String? id;
  String? trackingNumber;
  String? slug;
  String? orderId;

  Tracking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingNumber = json['tracking_number'];
    slug = json['slug'];
    orderId = json['order_id'];
  }
}
