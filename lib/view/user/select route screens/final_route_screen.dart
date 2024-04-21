import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../widgets/input/location_selector.dart';
import '../home page/components/pickup_destination_container.dart';

class FinalRouteScreen extends StatefulWidget {
  const FinalRouteScreen({super.key});

  @override
  State<FinalRouteScreen> createState() => _FinalRouteScreenState();
}

class _FinalRouteScreenState extends State<FinalRouteScreen> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();
  final _locationController = Location();
  late final GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 0.9,
                child: LocationSelector(
                  onLocationSelected: (LatLng location) {
                    pickUpCtrl.text = location.toString();
                    // debugPrint(location.toString());
                  },
                  onControllerCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 70.h, horizontal: 21.w),
                  child: PickUpDestContainer(
                    opacity: 0.95,
                    pickUpCtrl: pickUpCtrl,
                    destinationCtrl: destinationCtrl,
                  ),
                ),
              ),
            ],
          ),
          Text('Zaraaa'),
        ],
      ),
    );
  }

  Future<bool> accessPermission() async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return false;
    }

    permission = await _locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _locationController.requestPermission();
      return permission == PermissionStatus.granted;
    }
    return true;
  }
}
