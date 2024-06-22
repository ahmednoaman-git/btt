import 'dart:math';

import 'package:btt/model/entities/bus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/entities/graph.dart';
import '../model/entities/map_location.dart';

class PathSearchingUtils {
  static List<ViewablePath> getViewablePathFromEdges(List<Edge> edges, List<MapLocation> locations, List<Bus> busses) {
    final List<ViewablePath> viewablePaths = [];
    for (int i = 0; i < edges.length; i++) {
      final Edge currentEdge = edges[i];
      final location = locations.firstWhere((element) => element.id == currentEdge.destinationMapLocationId);

      // Initialize the current path with the current location in the iteration
      final List<MapLocation> currentPathLocations = [location];

      // Initialize the bus scores with the bus ids of the current edge each with a score of 0
      final Map<String, int> busScores = {
        for (final String busId in currentEdge.busIds) busId: 0,
      };

      bool currentPathHasCommonBusses = true;
      while (currentPathHasCommonBusses) {
        if (i == edges.length - 1) {
          // Get the bus id with the highest score and add a path with the current path locations and the bus
          final String mostRepeatedBusId = busScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
          final Bus bus = busses.firstWhere((element) => element.id == mostRepeatedBusId);
          viewablePaths.add(ViewablePath(currentPathLocations, bus));
          break;
        }

        final Edge nextEdge = edges[i + 1];

        // Get the bus combination of the current edge and the next edge
        final List busCombination = [
          currentEdge.busIds,
          nextEdge.busIds,
        ];

        final commonBusses = busCombination.fold<Set<String>>(
          busCombination.first.toSet(),
          (a, b) => a.intersection(b.toSet()),
        );

        // If no more busses are common between the current edge and the next edge, then the current path is complete
        if (commonBusses.isEmpty) {
          // Get the bus id with the highest score and add a path with the current path locations and the bus
          final String mostRepeatedBusId = busScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
          final Bus bus = busses.firstWhere((element) => element.id == mostRepeatedBusId);
          viewablePaths.add(ViewablePath(currentPathLocations, bus));
          break;
        }

        // If there are still common busses between the current edge and the next edge, then add the next location to the current path
        final location = locations.firstWhere((element) => element.id == nextEdge.destinationMapLocationId);
        currentPathLocations.add(location);

        // Update the bus scores with the common busses
        for (final String busId in commonBusses) {
          busScores[busId] = busScores[busId]! + 1;
        }

        i++;
      }
    }

    return viewablePaths;
  }

  static LatLng getBestCenterForPath(MapLocation start, MapLocation end) {
    // Convert latitude and longitude from degrees to radians
    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;

    // Calculate differences in the coordinates
    double dLon = lon2 - lon1;

    // Calculate the midpoint
    double bx = cos(lat2) * cos(dLon);
    double by = cos(lat2) * sin(dLon);

    double midLat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + by * by));
    double midLon = lon1 + atan2(by, cos(lat1) + bx);

    // Convert midpoint back to degrees
    double midLatDeg = midLat * 180 / pi;
    double midLonDeg = midLon * 180 / pi;

    return LatLng(midLatDeg, midLonDeg);
  }

  static double getBestZoomForPath(MapLocation start, MapLocation end) {
    final double distance = start.distanceToLocation(end);
    return distance * 0.39;
  }

  static Duration getTravelDurationForPath(MapLocation start, MapLocation end) {
    final double distance = start.distanceToLocation(end);
    return Duration(minutes: (distance / 0.5).round());
  }
}

class ViewablePath {
  final List<MapLocation> stops;
  final Bus bus;

  ViewablePath(this.stops, this.bus);
}
