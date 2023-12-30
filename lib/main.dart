import 'package:btt/model/entities/map_location.dart';
import 'package:btt/view/google_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<MapLocation> myStops = [
    MapLocation(id: '0', name: 'MyHome', latitude: 30.0734, longitude: 31.2806),
    MapLocation(id: '2', name: 'MyHome', latitude: 30.074416, longitude: 31.304850),
    MapLocation(id: '3', name: 'MyHome', latitude: 30.080122, longitude: 31.316457),
    MapLocation(id: '4', name: 'MyHome', latitude: 30.067486, longitude: 31.329847),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Transit Transportation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BusRoute(busAllStops: [
        LatLng(30.0734, 31.2806),
        LatLng(30.074416, 31.304850),
        LatLng(30.080122, 31.316457),
        LatLng(30.067486, 31.329847),
      ]),
    );
  }
}
