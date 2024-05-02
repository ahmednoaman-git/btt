import 'package:location/location.dart';

class LocationPermissionServices {

  Future<bool> accessPermission(Location locationController) async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return false;
    }

    permission = await locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locationController.requestPermission();
      return permission == PermissionStatus.granted;
    }
    return true;
  }
}