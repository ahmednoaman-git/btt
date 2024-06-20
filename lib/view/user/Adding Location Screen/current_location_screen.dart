import 'dart:async';

import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();

  LatLng? pickUpLocation;
  LatLng? destinationLocation;
  LatLng? lastHoveredLocation;

  final _locationController = Location();
  late final GoogleMapController _mapController;

  bool? pickUpSelectedForInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LocationSelector(
            onLocationSelected: (LatLng location) {
              lastHoveredLocation = location;
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
                    height: 70.r,
                    width: 70.r,
                    child: FloatingActionButton(
                      backgroundColor: AppColors.darkElevation.withOpacity(0.9),
                      shape: const CircleBorder(),
                      onPressed: () async {
                        bool granted = await accessPermission();
                        if (!granted) {
                          return;
                        }
                        LocationData userLocation = await _locationController.getLocation();
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
                        size: 35.r,
                      ),
                    ),
                  ),
                  22.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: MainButton(
                          text: (pickUpSelectedForInput ?? false) ? 'Done' : 'Set Pick Up',
                          color: (pickUpSelectedForInput ?? false) ? AppColors.accent1 : AppColors.darkElevation.withOpacity(0.9),
                          onPressed: () {
                            if (!(pickUpSelectedForInput ?? false)) {
                              setState(() {
                                pickUpSelectedForInput = true;
                              });
                            } else {
                              pickUpLocation = lastHoveredLocation;
                            }
                          },
                        ),
                      ),
                      22.horizontalSpace,
                      Expanded(
                        child: MainButton(
                          text: (pickUpSelectedForInput ?? true) ? 'Set Destination' : 'Done',
                          color: (pickUpSelectedForInput ?? true) ? AppColors.darkElevation.withOpacity(0.9) : AppColors.accent1,
                          onPressed: () {
                            if ((pickUpSelectedForInput ?? true)) {
                              setState(() {
                                pickUpSelectedForInput = false;
                              });
                            } else {
                              destinationLocation = lastHoveredLocation;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  22.verticalSpace,
                  MainButton(
                      text: 'Continue',
                      onPressed: () {
                        debugPrint('Pick Up: $pickUpLocation');
                        debugPrint('Destination: $destinationLocation');
                      }),
                  22.verticalSpace,
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
