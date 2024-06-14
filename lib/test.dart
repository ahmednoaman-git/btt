import 'package:btt/model/entities/map_location.dart';
import 'package:btt/services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {}

Future<MapLocation?> getNearestRegisteredLocation(LatLng targetLocation) async {
  final List<MapLocation> locations = (await LocationServices.getLocations()).data ?? [];
  double minDistance = double.infinity;
  MapLocation? nearestLocation;

  for (final MapLocation location in locations) {
    final double distance = location.distanceToLocationFromLatLng(targetLocation);
    if (distance < minDistance) {
      minDistance = distance;
      nearestLocation = location;
    }
  }

  return nearestLocation;
}
