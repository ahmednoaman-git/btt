import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BusRoute extends StatefulWidget {
  const BusRoute({super.key});

  @override
  State<BusRoute> createState() => _BusRouteState();
}

class _BusRouteState extends State<BusRoute> {
  final _locationController = Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  Map<PolylineId, Polyline> polylines = {};

  static const LatLng _pickUp = LatLng(30.0734, 31.2806);
  static const LatLng _destination = LatLng(30.067486, 31.329847);
  LatLng? _currentPosition;

  late String _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    getLocationUpdates().then(
      (_) => getPolyLinePoints().then(
        (coordinates) {
          generatePolyLineFromPoints(coordinates);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (_currentPosition == null)
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                  controller.setMapStyle(_darkMapStyle);
                },
                initialCameraPosition: const CameraPosition(
                  target: _pickUp,
                  zoom: 14,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId('pickup'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pickUp,
                  ),
                  const Marker(
                    markerId: MarkerId('_destination'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _destination,
                  ),
                  Marker(
                    markerId: const MarkerId('current'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    position: _currentPosition!,
                  )
                },
                polylines: Set<Polyline>.of(polylines.values),
              ),
      ),
    );
  }

  Future<void> updateCameraPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 14);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permission = await _locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _locationController.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData currentlocation) {
      if (currentlocation.longitude != null && currentlocation.latitude != null) {
        setState(() {
          _currentPosition = LatLng(currentlocation.latitude!, currentlocation.longitude!);
          updateCameraPosition(_currentPosition!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylinePoints = [];
    PolylinePoints polyPoints = PolylinePoints();
    PolylineResult result = await polyPoints.getRouteBetweenCoordinates(
      'AIzaSyB49dEcTb8Z1h1bvnCTaTt56ooJyFMPWLA',
      PointLatLng(_pickUp.latitude, _pickUp.longitude),
      PointLatLng(_destination.latitude, _destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var polyPoint in result.points) {
        polylinePoints.add(LatLng(polyPoint.latitude, polyPoint.longitude));
      }
    } else {
      debugPrint(' errorrrrrrrrrrrrrrrrrrrrrrrrrrrr : ${result.errorMessage}');
    }
    return polylinePoints;
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/themes/dark_map.json');
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.purple,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
