import 'package:btt/services/route_services.dart';
import 'package:btt/tools/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/entities/bus.dart';
import '../model/entities/map_location.dart';
import '../model/entities/route.dart';
import '../tools/response.dart';

class BusServices {
  static Future<Response<List<Bus>>> getBuses() async {
    bool success = false;
    final List<Bus> buses = [];
    await firestore
        .collection(
          'busses',
        )
        .get()
        .then((value) {
      buses.addAll([for (DocumentSnapshot doc in value.docs) Bus.fromDocumentSnapshot(doc)]);
      success = true;
    });

    if (success) {
      return Response.success(buses);
    } else {
      return Response.fail('Failed to get busses');
    }
  }

  static Future<Response<Bus>> createBus(Bus bus) async {
    bool success = false;
    await firestore
        .collection(
          'busses',
        )
        .add(bus.toJson())
        .then((value) {
      success = true;
    });

    if (success) {
      return Response.success(bus);
    } else {
      return Response.fail('Failed to create busses');
    }
  }

  // get busses by route id
  static Future<Response<List<Bus>>> getBussesByRouteId(String routeId) async {
    bool success = false;
    final List<Bus> buses = [];
    await firestore
        .collection(
          'busses',
        )
        .where('routeId', isEqualTo: routeId)
        .get()
        .then((value) {
      buses.addAll([for (DocumentSnapshot doc in value.docs) Bus.fromDocumentSnapshot(doc)]);
      success = true;
    });

    if (success) {
      return Response.success(buses);
    } else {
      return Response.fail('Failed to get busses');
    }
  }

  static Future<Response<List<Bus>>> getBussesThatPassByStationLocation(MapLocation location) async {
    final List<MapRoute> routes = ((await RouteServices.getRoutesThatIncludeLocation(location.id)) as Response).data ?? [];

    final List<Bus> busses = [];
    for (final MapRoute route in routes) {
      final List<Bus> bussesInRoute = (await BusServices.getBussesByRouteId(route.id)).data ?? [];
      busses.addAll(bussesInRoute);
    }

    return Response.success(busses);
  }

  // Get busses that pass by multiple locations (Each bus must pass through all of them)
  static Future<Response<List<Bus>>> getBussesThatPassByTwoLocations(String locationOneId, String locationTwoId) async {
    final List<MapRoute> routes = ((await RouteServices.getRoutesThatIncludeTwoLocations(locationOneId, locationTwoId)) as Response).data ?? [];

    final List<Bus> busses = [];
    for (final MapRoute route in routes) {
      final List<Bus> bussesInRoute = (await BusServices.getBussesByRouteId(route.id)).data ?? [];
      busses.addAll(bussesInRoute);
    }

    return Response.success(busses);
  }
}
