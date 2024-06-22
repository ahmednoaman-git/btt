import 'package:btt/model/entities/map_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapRoute {
  final String id;
  final String name;
  final List<MapLocation> stops;
  final MapLocation start;
  final MapLocation end;

  MapRoute({
    this.id = '',
    required this.name,
    required this.stops,
    required this.start,
    required this.end,
  });

  factory MapRoute.fromJson(Map<String, dynamic> json) {
    return MapRoute(
      id: json['id'],
      name: json['name'],
      stops: json['stops'].map<MapLocation>((stop) => MapLocation.fromJson(Map<String, dynamic>.from(stop))).toList(),
      start: MapLocation.fromJson(Map<String, dynamic>.from(json['start'])),
      end: MapLocation.fromJson(Map<String, dynamic>.from(json['end'])),
    );
  }

  factory MapRoute.fromDocumentSnapshot(DocumentSnapshot doc) {
    return MapRoute(
      id: doc.id,
      name: doc['name'],
      stops: doc['stops'].map<MapLocation>((stop) => MapLocation.fromJson(stop)).toList(),
      start: MapLocation.fromJson(doc['start']),
      end: MapLocation.fromJson(doc['end']),
    );
  }

  factory MapRoute.fromListOfLocations(String id, String name, List<MapLocation> locations) {
    return MapRoute(
      id: id,
      name: name,
      stops: locations,
      start: locations.first,
      end: locations.last,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false, bool includeStopsAsObjects = false}) {
    return {
      if (includeId) 'id': id,
      'name': name,
      'stops': includeStopsAsObjects ? stops.map((stop) => stop.toJson()).toList() : stops.map((stop) => stop.id).toList(),
      'start': includeStopsAsObjects ? start.toJson() : start.id,
      'end': includeStopsAsObjects ? end.toJson() : end.id,
    };
  }
}
