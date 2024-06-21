import 'package:btt/model/entities/map_location.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../tools/response.dart';

class UserServices {
  static Future<Response<bool>> createUser(String userId) async {
    bool success = false;
    await firestore.collection('users').doc(userId).set({
      'favorites': [],
      'recents': [],
    }).then((data) {
      success = true;
    });
    if (success) {
      return Response.success(true);
    } else {
      return Response.fail('Failed to create user');
    }
  }

  static Future<Response<bool>> addFavorite(String userId, String locationId) async {
    bool success = false;
    await firestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([locationId])
    }).then((data) {
      success = true;
    });
    if (success) {
      return Response.success(true);
    } else {
      return Response.fail('Failed to create location');
    }
  }

  static Future<List<MapLocation>> getFavoriteLocations(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<String> favorites = List<String>.from(data['favorites']) ?? [];
        final response = await LocationServices.getLocationsFromIds(favorites);
        return response.data!;
      } else {
        print('User document does not exist');
        return [];
      }
    } catch (error) {
      print('Error retrieving favorite locations: $error');
      return [];
    }
  }

  static Future<void> removeFavoriteLocation(String userId, String locationToRemove) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({
        'favorites': FieldValue.arrayRemove([locationToRemove])
      });
      print('Favorite location removed successfully!');
    } catch (error) {
      print('Error removing favorite location: $error');
    }
  }
}
