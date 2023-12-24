import 'map_location.dart';

class Bus {
  String id;
  String identifier; // Bus Name
  String routeId;
  DateTime departureTime;
  BusStatus status;
  MapLocation currentLocation;

  Bus({
    required this.id,
    required this.identifier,
    required this.routeId,
    required this.departureTime,
    required this.status,
    required this.currentLocation,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      identifier: json['identifier'],
      routeId: json['routeId'],
      departureTime: DateTime.parse(json['departureTime']),
      status: BusStatus.values[json['status']],
      currentLocation: MapLocation.fromJson(json['currentLocation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'routeId': routeId,
      'departureTime': departureTime.toIso8601String(),
      'status': status.index,
      'currentLocation': currentLocation.toJson(),
    };
  }
}

enum BusStatus {
  test,
}
