import 'package:btt/services/user_services.dart';
import 'package:flutter/material.dart';

import '../model/entities/map_location.dart';

class FavoritesProvider extends ChangeNotifier {
  List<MapLocation> favoriteLocations = [];
  bool isLoading = false;

  void setLoading(bool load) {
    isLoading = load;
    notifyListeners();
  }

  void fetchFavoriteLocations(String userId) async {
    setLoading(true);
    favoriteLocations = await UserServices.getFavoriteLocations(userId);
    setLoading(false);
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

  bool checkIsInFavorite(String locationId) {
    bool found = false;
    for (var location in favoriteLocations) {
      if (location.id == locationId) {
        found = true;
      }
    }
    return found;
  }
}
