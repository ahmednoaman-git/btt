import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  MapLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory MapLocation.fromJson(Map<String, dynamic> json) => MapLocation(
        id: json['id'],
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LatLng toLatLng() => LatLng(latitude, longitude);
}
