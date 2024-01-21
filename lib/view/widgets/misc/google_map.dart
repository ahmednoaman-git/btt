import 'dart:async';

import 'package:btt/model/entities/map_location.dart';
import 'package:btt/view/global/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../model/entities/route.dart';

class BusRoute extends StatefulWidget {
  final MapRoute route;
  const BusRoute({
    super.key,
    required this.route,
  });

  @override
  State<BusRoute> createState() => _BusRouteState();
}

class _BusRouteState extends State<BusRoute> {
  final _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  Map<PolylineId, Polyline> polylines = {};
  int count = 0;
  // LatLng? _currentPosition;
  late String _darkMapStyle;
  late final List<LatLng> busAllStops;

  @override
  void initState() {
    super.initState();
    busAllStops = widget.route.stops.map((MapLocation location) => location.toLatLng()).toList();
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
        body:
            // (_currentPosition == null)
            //     ? const Center(child: CircularProgressIndicator())
            //     :
            GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
            controller.setMapStyle(_darkMapStyle);
          },
          initialCameraPosition: CameraPosition(
            target: busAllStops.first,
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('pickup'),
              icon: BitmapDescriptor.defaultMarker,
              position: busAllStops.first,
            ),
            ...getOnlyStops().map((stop) {
              count++;
              return Marker(
                markerId: MarkerId('stop $count'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                position: stop,
                alpha: 0.5,
              );
            }).toList(),
            Marker(
              markerId: const MarkerId('destination'),
              icon: BitmapDescriptor.defaultMarker,
              position: busAllStops.last,
            ),
            // Marker(
            //   markerId: const MarkerId('current'),
            //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            //   position: _currentPosition!,
            // )
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
    // _locationController.onLocationChanged.listen((LocationData currentlocation) {
    //   if (currentlocation.longitude != null && currentlocation.latitude != null) {
    //     setState(() {
    //       _currentPosition = LatLng(currentlocation.latitude!, currentlocation.longitude!);
    //       updateCameraPosition(_currentPosition!);
    //     });
    //   }
    // });
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylinePoints = [];
    PolylinePoints polyPoints = PolylinePoints();
    for (var i = 0; i < busAllStops.length; i++) {
      if (i == busAllStops.length - 1) break;
      PolylineResult result = await polyPoints.getRouteBetweenCoordinates(
        Constants.googleMapsApiKey,
        PointLatLng(busAllStops[i].latitude, busAllStops[i].longitude),
        PointLatLng(busAllStops[i + 1].latitude, busAllStops[i + 1].longitude),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        for (var polyPoint in result.points) {
          polylinePoints.add(LatLng(polyPoint.latitude, polyPoint.longitude));
        }
      } else {
        debugPrint(' errorrrrrrrrrrrrrrrrrrrrrrrrrrrr : ${result.errorMessage}');
      }
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

  List<LatLng> getOnlyStops() {
    List<LatLng> onlyStops = [...busAllStops];
    onlyStops.removeAt(0);
    onlyStops.removeAt(onlyStops.length - 1);
    return onlyStops;
  }

  // LatLng getMidpoint(List<LatLng> allLocations) {
  //   LatLng first = allLocations.first;
  //   LatLng last = allLocations.last;
  //
  //   return LatLng((first.latitude + last.latitude) / 2, (first.longitude + last.longitude) / 2);
  // }

  // double getZoom(List<LatLng> allLocations) {
  //   LatLng first = allLocations.first;
  //   LatLng last = allLocations.last;
  //
  //   double distance =
  //       calculateDistance(first.latitude, first.longitude, last.latitude, last.longitude);
  //   double zoom = calculateZoomLevel(distance);
  //
  //   return zoom;
  // }
  //
  // double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  //   const double radius = 6371; // Earth's radius in kilometers
  //
  //   // Convert latitude and longitude from degrees to radians
  //   final double lat1Rad = _degreesToRadians(lat1);
  //   final double lon1Rad = _degreesToRadians(lon1);
  //   final double lat2Rad = _degreesToRadians(lat2);
  //   final double lon2Rad = _degreesToRadians(lon2);
  //
  //   // Calculate differences
  //   final double dLat = lat2Rad - lat1Rad;
  //   final double dLon = lon2Rad - lon1Rad;
  //
  //   // Haversine formula
  //   final double a =
  //       sin(dLat / 2) * sin(dLat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
  //   final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //
  //   // Distance in kilometers
  //   final double distance = radius * c;
  //
  //   return distance;
  // }
  //
  // double _degreesToRadians(double degrees) {
  //   return degrees * (pi / 180.0);
  // }
  //
  // double calculateZoomLevel(double distance) {
  //   // Manually adjusted values based on trial and error
  //   const double zoomConstant = 0.1;
  //   const double adjustmentFactor = 0.3; // Adjust as needed
  //
  //   double zoom = 21 - log(distance) / log(zoomConstant);
  //
  //   // Manual adjustment to find a better-suited zoom level
  //   return zoom - adjustmentFactor;
  // }
}
