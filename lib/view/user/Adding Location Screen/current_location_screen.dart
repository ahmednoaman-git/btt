import 'dart:async';

import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../home page/components/pickup_destination_container.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();
  final _locationController = Location();
  late final GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LocationSelector(
            onLocationSelected: (LatLng location) {
              pickUpCtrl.text = location.toString();
              // debugPrint(location.toString());
            },
            onControllerCreated: (GoogleMapController mapController) {
              _mapController = mapController;
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 22.r, horizontal: 15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80.r,
                    width: 80.r,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.darkElevation.withOpacity(0.9),
                      shape: const CircleBorder(),
                      onPressed: () async {
                        bool granted = await accessPermission();
                        if (!granted) {
                          return;
                        }
                        LocationData userLocation =
                            await _locationController.getLocation();
                        // destinationCtrl.text = userLocation.latitude.toString();
                        _mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(
                              userLocation.latitude!,
                              userLocation.longitude!,
                            ),
                            14,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 40.r,
                      ),
                    ),
                  ),
                  22.verticalSpace,
                  Hero(
                    tag: 'cont',
                    child: PickUpDestContainer(
                      opacity: 0.95,
                      pickUpCtrl: pickUpCtrl,
                      destinationCtrl: destinationCtrl,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
