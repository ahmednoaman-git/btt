import 'package:btt/model/entities/bus.dart';
import 'package:btt/model/entities/graph.dart';
import 'package:btt/model/entities/map_location.dart';
import 'package:btt/model/entities/route.dart';
import 'package:btt/services/bus_services.dart';
import 'package:btt/services/route_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class CacheManager extends ChangeNotifier {
  final box = Hive.box('db');
  bool _graphIsInCache = false;
  bool _loading = false;
  late Graph _graph;

  bool get graphIsInCache => _graphIsInCache;
  bool get loading => _loading;

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
      return;
    }

    setGraphIsInCache(false);
    await _createGraph();
  }

  Future<void> _createGraph() async {
    final List<MapRoute> routes = (await RouteServices.getRoutes()).data ?? [];
    final List<Bus> buses = (await BusServices.getBuses()).data ?? [];
    final Graph graph = Graph(adjacencyList: {});

    for (final route in routes) {
      for (int i = 0; i < route.stops.length - 1; i++) {
        final List<String> routeBusses = buses.where((b) => b.routeId == route.id).map((b) => b.id).toList();
        final MapLocation firstNode = route.stops[i];
        final MapLocation secondNode = route.stops[i + 1];
        final double distance = firstNode.distanceToLocation(secondNode);

        final Edge edge = Edge(destinationMapLocationId: secondNode.id, weight: distance, busIds: routeBusses);
        graph.addEdge(firstNode.id, edge);
      }
    }

    debugPrint(graph.toString());

    box.put('graph', graph.toJson());
  }
}
