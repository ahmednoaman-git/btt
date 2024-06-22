import 'package:flutter/cupertino.dart';

class Graph {
  final Map<String, List<Edge>> adjacencyList;

  Graph({required this.adjacencyList});

  void addEdge(String sourceMapLocationId, Edge edge) {
    if (!adjacencyList.containsKey(sourceMapLocationId)) {
      adjacencyList[sourceMapLocationId] = [];
    }
    if (!adjacencyList[sourceMapLocationId]!.any((e) => e.destinationMapLocationId == edge.destinationMapLocationId)) {
      adjacencyList[sourceMapLocationId]!.add(edge);
    }

    if (!adjacencyList.containsKey(edge.destinationMapLocationId)) {
      adjacencyList[edge.destinationMapLocationId] = [];
    }
    if (!adjacencyList[edge.destinationMapLocationId]!.any((e) => e.destinationMapLocationId == sourceMapLocationId)) {
      adjacencyList[edge.destinationMapLocationId]!.add(
        Edge(
          destinationMapLocationId: sourceMapLocationId,
          weight: edge.weight,
          busIds: edge.busIds,
        ),
      );
    }
  }

  List<String> getNodes() {
    return adjacencyList.keys.toList();
  }

  List<Edge> getEdges(String sourceMapLocationId) {
    return adjacencyList[sourceMapLocationId] ?? [];
  }

  List<Edge> dijkstra(String firstNode, String lastNode) {
    final distances = <String, double>{};
    final previousNodes = <String, String>{};
    final pq = PriorityQueue<_PriorityQueueItem>((a, b) => a.priority.compareTo(b.priority));

    distances[firstNode] = 0;
    pq.add(_PriorityQueueItem(node: firstNode, priority: 0));

    while (pq.isNotEmpty) {
      final current = pq.removeFirst().node;

      if (current == lastNode) {
        break;
      }

      for (final edge in getEdges(current)) {
        final newDistance = distances[current]! + edge.weight;
        if (newDistance < (distances[edge.destinationMapLocationId] ?? double.infinity)) {
          distances[edge.destinationMapLocationId] = newDistance;
          previousNodes[edge.destinationMapLocationId] = current;
          pq.add(_PriorityQueueItem(node: edge.destinationMapLocationId, priority: newDistance));
        }
      }
    }

    return _buildPath(previousNodes, firstNode, lastNode);
  }

  List<Edge> _buildPath(Map<String, String> previousNodes, String startNode, String endNode) {
    final path = <Edge>[];
    var currentNode = endNode;

    while (currentNode != startNode) {
      final previousNode = previousNodes[currentNode];
      if (previousNode == null) {
        return []; // No path found
      }

      final edge = getEdges(previousNode).firstWhere(
        (edge) => edge.destinationMapLocationId == currentNode,
      );

      path.add(edge);
      currentNode = previousNode;
    }

    return path.reversed.toList();
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

class PriorityQueue<T> {
  final List<T> _heap = [];
  final Comparator<T> _comparator;

  PriorityQueue(this._comparator);

  bool get isEmpty => _heap.isEmpty;

  bool get isNotEmpty => _heap.isNotEmpty;

  void add(T value) {
    _heap.add(value);
    _heapifyUp(_heap.length - 1);
  }

  T removeFirst() {
    if (_heap.isEmpty) {
      throw StateError('PriorityQueue is empty');
    }

    final value = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _heapifyDown(0);
    }

    return value;
  }

  void _heapifyUp(int index) {
    while (index > 0) {
      final parentIndex = (index - 1) >> 1;
      if (_comparator(_heap[index], _heap[parentIndex]) >= 0) {
        break;
      }
      _swap(index, parentIndex);
      index = parentIndex;
    }
  }

  void _heapifyDown(int index) {
    final length = _heap.length;
    while (index < length) {
      final leftChildIndex = (index << 1) + 1;
      final rightChildIndex = leftChildIndex + 1;

      int smallest = index;

      if (leftChildIndex < length && _comparator(_heap[leftChildIndex], _heap[smallest]) < 0) {
        smallest = leftChildIndex;
      }

      if (rightChildIndex < length && _comparator(_heap[rightChildIndex], _heap[smallest]) < 0) {
        smallest = rightChildIndex;
      }

      if (smallest == index) {
        break;
      }

      _swap(index, smallest);
      index = smallest;
    }
  }

  void _swap(int index1, int index2) {
    final temp = _heap[index1];
    _heap[index1] = _heap[index2];
    _heap[index2] = temp;
  }
}

class _PriorityQueueItem {
  final String node;
  final double priority;

  _PriorityQueueItem({
    required this.node,
    required this.priority,
  });
}
