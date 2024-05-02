import 'package:btt/providers/choose_on_map_provider.dart';
import 'package:btt/providers/map_provider.dart';
import 'package:btt/view/user/Adding%20Location%20Screen/components/column_on_map.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();
  final _locationController = Location();
  // late final GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ChooseOnMapProvider,MapProvider>(
      builder: (context, ChooseOnMapProvider,MapProvider,_){
        return Scaffold(
          body: Stack(
            children: [
              LocationSelector(
                onLocationSelected: (LatLng location) {
                  pickUpCtrl.text = location.toString();
                },
                onControllerCreated: (GoogleMapController mapController) {
                  MapProvider.mapController = mapController;
                },
              ),
              Align(
                alignment: ChooseOnMapProvider.isSelected
                    ? Alignment.center
                    : Alignment.bottomCenter,
                child: AnimatedContainer(
                  color: ChooseOnMapProvider.isSelected
                      ? Colors.black.withOpacity(0.65)
                      : Colors.transparent,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 22.r, horizontal: 15.r),
                    child: ColumnOnMap(
                      pickUpCtrl: pickUpCtrl,
                      destinationCtrl: destinationCtrl,
                      locationController: _locationController,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
