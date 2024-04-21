import 'package:btt/model/entities/bus.dart';
import 'package:btt/model/entities/route.dart';
import 'package:btt/services/route_services.dart';
import 'package:btt/tools/response.dart';
import 'package:btt/view/widgets/api/request_widget.dart';
import 'package:btt/view/widgets/misc/google_map.dart';
import 'package:flutter/material.dart';

class BusRouteScreen extends StatefulWidget {
  final Bus bus;
  const BusRouteScreen({super.key, required this.bus});

  @override
  State<BusRouteScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<BusRouteScreen> {
  late final Future<Response<MapRoute>> route;

  @override
  void initState() {
    route = RouteServices.getRouteFromId(widget.bus.routeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequestWidget<MapRoute>(
        request: route,
        successWidgetBuilder: (MapRoute busRoute) {
          return BusRoute(
            route: busRoute,
          );
        },
      ),
    );
  }
}
