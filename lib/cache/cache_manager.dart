import 'package:btt/model/entities/bus.dart';
import 'package:btt/model/entities/graph.dart';
import 'package:btt/model/entities/map_location.dart';
import 'package:btt/model/entities/route.dart';
import 'package:btt/services/bus_services.dart';
import 'package:btt/services/route_services.dart';
import 'package:btt/utils/path_searching_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class CacheManager extends ChangeNotifier {
  final box = Hive.box('db');
  bool _graphIsInCache = false;
  bool _loading = false;
  late Graph _graph;
  late Map<String, MapLocation> _locations;
  late Map<String, Bus> _buses;
  late Map<String, MapRoute> _routes;

  bool get graphIsInCache => _graphIsInCache;
  bool get loading => _loading;
  Graph get graph => _graph;
  Map<String, MapLocation> get locations => _locations;
  Map<String, Bus> get buses => _buses;
  Map<String, MapRoute> get routes => _routes;

  void setGraphIsInCache(bool value) {
    _graphIsInCache = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> init() async {
    setLoading(true);
    final Map<dynamic, dynamic> cache = box.get('graph', defaultValue: {});
    if (cache.isNotEmpty) {
      setGraphIsInCache(true);
      setLoading(false);
      _graph = Graph.fromJson(Map<String, dynamic>.from(cache));
      debugPrint('Graph: $_graph');
      _locations = {
        for (var e in box.get('locations', defaultValue: []).map(
          (e) => MapLocation.fromJson(Map<String, dynamic>.from(e)),
        ))
          e.id: e,
      };

      _buses = {
        for (var e in box.get('buses', defaultValue: []).map(
          (e) => Bus.fromJson(Map<String, dynamic>.from(e), readDateAsTimestamp: false),
        ))
          e.id: e,
      };

      _routes = {
        for (var e in box.get('routes', defaultValue: []).map(
          (e) => MapRoute.fromJson(Map<String, dynamic>.from(e)),
        ))
          e.id: e,
      };

      // Testing
      const String testIdLocationOne = 'XXrpG5JQuhymFREh0VQ4';
      const String testIdLocationTwo = 'D0Nl9y8YqubxtNCtpuXK';

      final path = _graph.dijkstra(testIdLocationOne, testIdLocationTwo);
      debugPrint('Path: $path');
      final List<ViewablePath> viewablePath = PathSearchingUtils.getViewablePathFromEdges(path, _locations.values.toList(), _buses.values.toList());
      return;
    }

    setGraphIsInCache(false);
    await _createGraph();
  }

  Future<void> _createGraph() async {
    final List<MapRoute> routes = (await RouteServices.getRoutes()).data ?? [];
    final List<Bus> buses = (await BusServices.getBuses()).data ?? [];

    // Cache
    final List<MapLocation> locations = [];

    final Graph graph = Graph(adjacencyList: {});

    for (final route in routes) {
      for (int i = 0; i < route.stops.length - 1; i++) {
        final List<String> routeBusses = buses.where((b) => b.routeId == route.id).map((b) => b.id).toList();
        final MapLocation firstNode = route.stops[i];
        final MapLocation secondNode = route.stops[i + 1];
        final double distance = firstNode.distanceToLocation(secondNode);

        final Edge edge = Edge(destinationMapLocationId: secondNode.id, weight: distance, busIds: routeBusses);
        graph.addEdge(firstNode.id, edge);

        if (!locations.contains(firstNode)) {
          locations.add(firstNode);
        }
        if (i == route.stops.length - 2 && !locations.contains(secondNode)) {
          locations.add(secondNode);
        }
      }
    }

    debugPrint(graph.toString());

    box.put('graph', graph.toJson());
    box.put('locations', locations.map((e) => e.toJson(includeId: true)).toList());
    box.put('buses', buses.map((e) => e.toJson(convertToTimestamp: false, includeId: true)).toList());
    box.put('routes', routes.map((e) => e.toJson(includeId: true, includeStopsAsObjects: true)).toList());
  }
}
