import 'package:btt/model/entities/map_location.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/response.dart';
import 'package:btt/view/google_map.dart';
import 'package:btt/view/widgets/api/request_widget.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final Future<Response<List<MapLocation>>> request = LocationServices.getLocations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequestWidget<List<MapLocation>>(
        request: request,
        successWidgetBuilder: (List<MapLocation> locations) {
          return BusRoute(
            busAllStops: locations.map((e) => e.toLatLng()).toList(),
          );
        },
      ),
    );
  }
}
