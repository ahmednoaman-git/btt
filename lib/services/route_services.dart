import 'package:btt/model/entities/route.dart';
import 'package:btt/tools/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../tools/response.dart';

class RouteServices {
  static Future<Response<List<Route>>> getRoutes() async {
    bool success = false;
    final List<Route> routes = [];
    await firestore
        .collection(
          'routes',
        )
        .get()
        .then((value) {
      routes.addAll([for (DocumentSnapshot doc in value.docs) Route.fromDocumentSnapshot(doc)]);
      success = true;
    });

    if (success) {
      return Response.success(routes);
    } else {
      return Response.fail('Failed to get routes');
    }
  }

  // Create route
  static Future<Response<Route>> createRoute(Route route) async {
    bool success = false;
    await firestore
        .collection(
          'routes',
        )
        .add(route.toJson())
        .then((value) {
      success = true;
    });

    if (success) {
      return Response.success(route);
    } else {
      return Response.fail('Failed to create route');
    }
  }
}
