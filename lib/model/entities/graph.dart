import 'package:flutter/cupertino.dart';

class Graph {
  final Map<String, List<Edge>> adjacencyList;

  Graph({required this.adjacencyList});

  void addEdge(String sourceMapLocationId, Edge edge) {
    if (!adjacencyList.containsKey(sourceMapLocationId)) {
      adjacencyList[sourceMapLocationId] = [];
    }
    adjacencyList[sourceMapLocationId]!.add(edge);

    if (!adjacencyList.containsKey(edge.destinationMapLocationId)) {
      adjacencyList[edge.destinationMapLocationId] = [];
    }
    adjacencyList[edge.destinationMapLocationId]!.add(
      Edge(
        destinationMapLocationId: sourceMapLocationId,
        weight: edge.weight,
        busIds: edge.busIds,
      ),
    );
  }

  List<Edge> getEdges(String sourceMapLocationId) {
    return adjacencyList[sourceMapLocationId] ?? [];
  }

  @override
  String toString() {
    String result = '';
    for (final source in adjacencyList.keys) {
      result += '$source -> ';
      for (final edge in adjacencyList[source]!) {
        result += '${edge.destinationMapLocationId} ';
      }
      result += '\n';
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'adjacencyList': adjacencyList.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
    };
  }

  factory Graph.fromJson(Map<String, dynamic> json) {
    debugPrint(json['adjacencyList'].runtimeType.toString());
    return Graph(
      adjacencyList: Map<String, dynamic>.from(json['adjacencyList']).map(
        (key, value) => MapEntry(
          key,
          List<Edge>.from(
            value.map((e) => Edge.fromJson(Map<String, dynamic>.from(e))),
          ),
        ),
      ),
    );
  }
}

class Edge {
  final String destinationMapLocationId;
  final double weight;
  final List<String> busIds;

  Edge({
    required this.destinationMapLocationId,
    required this.weight,
    required this.busIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'destinationMapLocationId': destinationMapLocationId,
      'weight': weight,
      'busIds': busIds,
    };
  }

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      destinationMapLocationId: json['destinationMapLocationId'],
      weight: json['weight'],
      busIds: List<String>.from(json['busIds']),
    );
  }
}
