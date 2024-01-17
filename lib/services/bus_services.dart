import 'package:btt/tools/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/entities/bus.dart';
import '../tools/response.dart';

class BusServices {
  static Future<Response<List<Bus>>> getBuses() async {
    bool success = false;
    final List<Bus> buses = [];
    await firestore
        .collection(
          'Busses',
        )
        .get()
        .then((value) {
      buses.addAll([for (DocumentSnapshot doc in value.docs) Bus.fromDocumentSnapshot(doc)]);
      success = true;
    });

    if (success) {
      return Response.success(buses);
    } else {
      return Response.fail('Failed to get busses');
    }
  }

  static Future<Response<Bus>> createBus(Bus bus) async {
    bool success = false;
    await firestore
        .collection(
          'busses',
        )
        .add(bus.toJson())
        .then((value) {
      success = true;
    });

    if (success) {
      return Response.success(bus);
    } else {
      return Response.fail('Failed to create busses');
    }
  }
}
