import 'package:btt/model/entities/traversed_route.dart';

class Trip {
  String id;
  String userId;
  List<TraversedRoute> routes;
  DateTime startTime;
  DateTime endTime;
  double distance; // In meters
  double fare; // In EGP

  Trip({
    required this.id,
    required this.userId,
    required this.routes,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.fare,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['userId'],
      routes: json['routes'].map<TraversedRoute>((route) => TraversedRoute.fromJson(route)).toList(),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      distance: json['distance'],
      fare: json['fare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routes': routes.map((route) => route.toJson()).toList(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'fare': fare,
    };
  }
}
