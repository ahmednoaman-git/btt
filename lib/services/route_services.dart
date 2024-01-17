import 'package:btt/model/entities/map_location.dart';
import 'package:btt/model/entities/route.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/firebase_instances.dart';
import 'package:btt/tools/response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteServices {
  static Future<Response<List<MapRoute>>> getRoutes() async {
    bool success = false;
    final List<MapRoute> routes = [];
    await firestore
        .collection(
          'routes',
        )
        .get()
        .then((value) async {
      for (DocumentSnapshot doc in value.docs) {
        final Response<List<MapLocation>> stopsResponse =
            await LocationServices.getLocationsFromIds(
                (doc['stops'] as List<dynamic>).cast<String>());
        if (!stopsResponse.success) {
          success = false;
          return Response.fail('Failed to get stops');
        }
        routes.add(MapRoute.fromListOfLocations(
          doc.id,
          doc['name'],
          stopsResponse.data!,
        ));
      }
      success = true;
    });

    if (success) {
      return Response.success(routes);
    } else {
      return Response.fail('Failed to get routes');
    }
  }

  static Future<Response<MapRoute>> getRouteFromId(String id) async {
    bool success = false;
    late MapRoute route;
    await firestore
        .collection(
          'routes',
        )
        .doc(id)
        .get()
        .then((doc) async {
      final Response<List<MapLocation>> stopsResponse = await LocationServices.getLocationsFromIds(
          (doc['stops'] as List<dynamic>).cast<String>());
      if (!stopsResponse.success) {
        success = false;
        return Response.fail('Failed to get stops');
      }
      route = MapRoute.fromListOfLocations(
        doc.id,
        doc['name'],
        stopsResponse.data!,
      );
      success = true;
    });
    if (success) {
      return Response.success(route);
    } else {
      return Response.fail('Failed to get route');
    }
  }

  static Future<Response<MapRoute>> createRoute(MapRoute route) async {
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
