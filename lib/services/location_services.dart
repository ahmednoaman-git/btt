import 'package:btt/model/entities/map_location.dart';
import 'package:btt/tools/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../tools/response.dart';

class LocationServices {
  static Future<Response<List<MapLocation>>> getLocations() async {
    bool success = false;
    final List<MapLocation> locations = [];
    await firestore
        .collection(
          'locations',
        )
        .get()
        .then((value) {
      locations.addAll([for (DocumentSnapshot doc in value.docs) MapLocation.fromDocumentSnapshot(doc)]);
      success = true;
    });

    if (success) {
      return Response.success(locations);
    } else {
      return Response.fail('Failed to get locations');
    }
  }

  // Create location
  static Future<Response<MapLocation>> createLocation(MapLocation location) async {
    bool success = false;
    await firestore
        .collection(
          'locations',
        )
        .add(location.toJson())
        .then((value) {
      success = true;
    });

    if (success) {
      return Response.success(location);
    } else {
      return Response.fail('Failed to create location');
    }
  }
}
