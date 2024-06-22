import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  MapLocation({
    this.id = '',
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  static MapLocation emptyLocation() => MapLocation(
        name: '',
        latitude: 0,
        longitude: 0,
      );

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      id: json['id'] ?? '',
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  factory MapLocation.fromDocumentSnapshot(DocumentSnapshot doc) {
    return MapLocation(
      id: doc.id,
      name: doc['name'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LatLng toLatLng() => LatLng(latitude, longitude);

  double distanceToLocationFromLatLng(LatLng location) {
    return distanceToLocation(MapLocation(
      name: '',
      latitude: location.latitude,
      longitude: location.longitude,
    ));
  }

  double distanceToLocation(MapLocation location) {
    const earthRadiusKm = 6371.0;

    double dLat = _degreesToRadians(location.latitude - latitude);
    double dLon = _degreesToRadians(location.longitude - longitude);

    double lat1 = _degreesToRadians(latitude);
    double lat2 = _degreesToRadians(location.latitude);

    double a = sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
