class TraversedRoute {
  String id;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  DateTime startTime;
  DateTime endTime;
  double distance; // In meters
  double fare; // In EGP
  RouteType type;
  String vehicleId;

  TraversedRoute({
    required this.id,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.fare,
    required this.type,
    required this.vehicleId,
  });

  factory TraversedRoute.fromJson(Map<String, dynamic> json) {
    return TraversedRoute(
      id: json['id'],
      startLatitude: json['startLatitude'],
      startLongitude: json['startLongitude'],
      endLatitude: json['endLatitude'],
      endLongitude: json['endLongitude'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      distance: json['distance'],
      fare: json['fare'],
      type: RouteType.values[json['type']],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'fare': fare,
      'type': type.index,
      'vehicleId': vehicleId,
    };
  }
}

enum RouteType {
  bus,
  metro,
  walk,
}
