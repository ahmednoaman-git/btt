import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapProvider extends ChangeNotifier{
  late GoogleMapController mapController;

  void changeMapController(LocationData userLocation){
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          userLocation.latitude!,
          userLocation.longitude!,
        ),
        14,
      ),
    );
    notifyListeners();
  }
}