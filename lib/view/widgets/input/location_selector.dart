import 'dart:async';

import 'package:btt/view/global/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSelector extends StatefulWidget {
  final void Function(LatLng)? onLocationSelected;
  final void Function(GoogleMapController)? onControllerCreated;
  const LocationSelector(
      {super.key, this.onLocationSelected, this.onControllerCreated});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late String _darkMapStyle;
  CameraPosition? _currentCameraPosition;

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.r),
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              widget.onControllerCreated?.call(controller);
              controller.setMapStyle(_darkMapStyle);
            },
            initialCameraPosition: _currentCameraPosition ??
                const CameraPosition(
                    target: LatLng(30.0734, 31.2806), zoom: 14),
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            onCameraMove: (CameraPosition position) {
              _currentCameraPosition = position;
            },
            onCameraIdle: () {
              widget.onLocationSelected?.call(_currentCameraPosition?.target ??
                  const LatLng(30.0734, 31.2806));
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            top: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.r),
              child: Icon(
                Icons.location_on_rounded,
                color: AppColors.accent1,
                size: 50.r,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/themes/dark_map.json');
  }
}
