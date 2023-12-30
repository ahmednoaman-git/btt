import 'dart:async';

import 'package:btt/view/global/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BusRoute extends StatefulWidget {
  final List<LatLng> busAllStops;
  const BusRoute({super.key, required this.busAllStops});

  @override
  State<BusRoute> createState() => _BusRouteState();
}

class _BusRouteState extends State<BusRoute> {
  final _locationController = Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  Map<PolylineId, Polyline> polylines = {};

  // static const List<LatLng> widget.busAllStops = [
  //   LatLng(30.0734, 31.2806),
  //   LatLng(30.080122, 31.316457),
  //   LatLng(30.067486, 31.329847),
  // ];
  int count = 0;

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
            target: widget.busAllStops[0],
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: MarkerId('pickup'),
              icon: BitmapDescriptor.defaultMarker,
              position: widget.busAllStops[0],
            ),
            ...getOnlyStops().map((stop) {
              count++;
              return Marker(
                markerId: MarkerId('stop $count'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                position: stop,
              );
            }).toList(),
            Marker(
              markerId: MarkerId('_destination'),
              icon: BitmapDescriptor.defaultMarker,
              position: widget.busAllStops[widget.busAllStops.length - 1],
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
    for (var i = 0; i < widget.busAllStops.length; i++) {
      if (i == widget.busAllStops.length - 1) break;
      PolylineResult result = await polyPoints.getRouteBetweenCoordinates(
        Constants.googleMapsApiKey,
        PointLatLng(widget.busAllStops[i].latitude, widget.busAllStops[i].longitude),
        PointLatLng(widget.busAllStops[i + 1].latitude, widget.busAllStops[i + 1].longitude),
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
    List<LatLng> onlyStops = [...widget.busAllStops];
    onlyStops.removeAt(0);
    onlyStops.removeAt(onlyStops.length - 1);
    return onlyStops;
  }
}
