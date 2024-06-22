import 'package:advanced_graphview/graph_node.dart';
import 'package:advanced_graphview/widgets/game_screen_widget.dart';
import 'package:btt/cache/cache_manager.dart';
import 'package:btt/model/entities/graph.dart' as entity;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphViewScreen extends StatefulWidget {
  const GraphViewScreen({super.key});

  @override
  State<GraphViewScreen> createState() => _GraphViewScreenState();
}

class _GraphViewScreenState extends State<GraphViewScreen> {
  bool _viewGraphInitialized = false;
  late GraphNode _graphNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<CacheManager>(builder: (context, cacheManager, _) {
        if (cacheManager.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (cacheManager.graphIsInCache) {
          if (!_viewGraphInitialized) {
            _graphNode = getViewGraphRoot(cacheManager.graph);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _viewGraphInitialized = true;
              });
            });
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }

        return InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(500),
          minScale: 0.5,
          child: AdvancedGraphviewWidget(
            nodePadding: 20,
            nodeSize: 50,
            pixelRatio: 10,
            graphNode: _graphNode,
            builder: (GraphNode graphNode) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  graphNode.id,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  GraphNode getViewGraphRoot(entity.Graph graphEntity) {
    final List<GraphViewNode> graphNodes = graphEntity.getNodes().map((e) => GraphViewNode(e, [])).toList();

    for (final GraphViewNode graphNode in graphNodes) {
      for (final entity.Edge edge in graphEntity.getEdges(graphNode.id)) {
        final GraphViewNode destinationNode = graphNodes.firstWhere((element) => element.id == edge.destinationMapLocationId);
        graphNode.graphNodes.add(destinationNode);
      }
    }

    return graphNodes.first;
  }
}

class GraphViewNode extends GraphNode {
  final String _id;
  final List<GraphViewNode> _graphNodes;

  GraphViewNode(this._id, this._graphNodes);

  @override
  List<GraphNode> get graphNodes => _graphNodes;

  @override
  String get id => _id;
}

// class _GraphViewScreenState extends State<GraphViewScreen> {
//   bool _graphInitialized = false;
//   final Graph graph = Graph();
//   BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
//
//   @override
//   void initState() {
//     builder
//       ..siblingSeparation = (100)
//       ..levelSeparation = (150)
//       ..subtreeSeparation = (150)
//       ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
//     super.initState();
//   }
//
//   void initializeViewableGraph(entity.Graph graphEntity) {
//     final List<Node> nodes = graphEntity.getNodes().map((e) => Node.Id(e)).toList();
//     for (final Node node in nodes) {
//       graph.addNode(node);
//     }
//
//     for (final Node node in nodes) {
//       for (final entity.Edge edge in graphEntity.getEdges(node.key?.value as String)) {
//         final Node destinationNode = nodes.firstWhere((element) => element.key?.value == edge.destinationMapLocationId);
//         graph.addEdge(node, destinationNode);
//         debugPrint(graph.nodes.length.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<CacheManager>(builder: (context, cacheManager, _) {
//         if (cacheManager.loading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         if (cacheManager.graphIsInCache) {
//           if (!_graphInitialized) {
//             initializeViewableGraph(cacheManager.graph);
//             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//               setState(() {
//                 _graphInitialized = true;
//               });
//             });
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             debugPrint('building: $_graphInitialized');
//             return Center(
//               child: InteractiveViewer(
//                 boundaryMargin: EdgeInsets.all(50),
//                 child: GraphView(
//                   graph: graph,
//                   algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
//                   paint: Paint()
//                     ..color = Colors.black
//                     ..strokeWidth = 1
//                     ..style = PaintingStyle.fill,
//                   builder: (Node node) {
//                     return GestureDetector(
//                       onTap: () {
//                         print(node.key);
//                       },
//                       child: Container(
//                         key: ValueKey(node.key),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           node.key.toString(),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );
//           }
//         }
//
//         return const Center(
//           child: Text('Graph not found'),
//         );
//       }),
//     );
//   }
// }
