import 'package:btt/model/entities/map_location.dart';

class Route {
  String id;
  List<MapLocation> stops;
  MapLocation start;
  MapLocation end;

  Route({
    required this.id,
    required this.stops,
    required this.start,
    required this.end,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      stops: json['stops'].map<MapLocation>((stop) => MapLocation.fromJson(stop)).toList(),
      start: MapLocation.fromJson(json['start']),
      end: MapLocation.fromJson(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }
}
