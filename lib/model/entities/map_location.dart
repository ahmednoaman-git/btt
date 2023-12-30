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

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      id: json['id'],
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LatLng toLatLng() => LatLng(latitude, longitude);
}
