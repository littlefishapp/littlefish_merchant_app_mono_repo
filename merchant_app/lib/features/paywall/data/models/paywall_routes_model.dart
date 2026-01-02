class PaywallRoutesModel {
  List<String> fromJson(Map<dynamic, dynamic> json) {
    var routes = <String>[];
    if (json.containsKey('routes')) {
      var routesFromJson = json['routes'];
      if (routesFromJson is List) {
        routes = routesFromJson.map((route) => route.toString()).toList();
      }
    }
    return routes;
  }
}
