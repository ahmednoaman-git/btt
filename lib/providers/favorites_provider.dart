import 'package:flutter/material.dart';

import '../model/entities/map_location.dart';

class FavoritesProvider extends ChangeNotifier {
  late List<MapLocation> favoriteLocations;

  void fetchFavoriteLocations(String userId) {
    // fetch favorite locations from FireStore
  }

  void addLocation(MapLocation mapLocation) {
    favoriteLocations.add(mapLocation);
    notifyListeners();
  }

  void deleteLocation(MapLocation mapLocation) {
    favoriteLocations.removeWhere((location) {
      return location.id == mapLocation.id;
    });
    notifyListeners();
  }
}
