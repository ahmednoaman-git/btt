import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchScreenProvider extends ChangeNotifier {
  LatLng? _startLocation;
  LatLng? _destinationLocation;

  LatLng? get startLocation => _startLocation;
  LatLng? get destinationLocation => _destinationLocation;

  void setStartLocation(LatLng location) {
    _startLocation = location;
    notifyListeners();
  }

  void setDestinationLocation(LatLng location) {
    _destinationLocation = location;
    notifyListeners();
  }

  LatLng? currentlySelectedLocation;

  void clear() {
    _startLocation = null;
    _destinationLocation = null;
    notifyListeners();
  }
}
