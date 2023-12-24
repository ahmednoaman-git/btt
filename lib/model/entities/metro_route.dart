import 'map_location.dart';

class MetroRoute {
  String id;
  int index;
  List<MapLocation> stops;

  MetroRoute({
    required this.id,
    required this.index,
    required this.stops,
  });

  factory MetroRoute.fromJson(Map<String, dynamic> json) {
    return MetroRoute(
      id: json['id'],
      index: json['index'],
      stops: json['stops'].map<MapLocation>((stop) => MapLocation.fromJson(stop)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'stops': stops.map((stop) => stop.toJson()).toList(),
    };
  }
}
