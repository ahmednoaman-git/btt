import 'package:cloud_firestore/cloud_firestore.dart';

import 'map_location.dart';

class Bus {
  String id;
  String identifier; // Bus Name
  String routeId;
  DateTime departureTime;
  BusStatus status;
  MapLocation currentLocation;
  double fare;

  Bus({
    required this.id,
    required this.identifier,
    required this.routeId,
    required this.departureTime,
    required this.status,
    required this.currentLocation,
    required this.fare,
  });

  static Bus emptyBus() => Bus(
        id: '',
        identifier: 'DummyBus',
        routeId: '',
        departureTime: DateTime.now(),
        status: BusStatus.outOfService,
        currentLocation: MapLocation.emptyLocation(),
        fare: 0,
      );

  factory Bus.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Bus.fromJson({
      'id': doc.id,
      ...(doc.data() as Map<String, dynamic>),
    });
  }

  factory Bus.fromJson(Map<String, dynamic> json, {bool readDateAsTimestamp = true}) {
    return Bus(
      id: json['id'],
      identifier: json['identifier'],
      routeId: json['routeId'],
      departureTime: readDateAsTimestamp ? (json['departureTime'] as Timestamp).toDate() : json['departureTime'],
      status: BusStatus.values[json['status']],
      currentLocation: MapLocation.fromJson(Map<String, dynamic>.from(json['currentLocation'])),
      fare: json['fare'],
    );
  }

  Map<String, dynamic> toJson({bool convertToTimestamp = true, bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      'identifier': identifier,
      'routeId': routeId,
      'departureTime': convertToTimestamp ? Timestamp.fromDate(departureTime) : departureTime,
      'status': status.index,
      'currentLocation': currentLocation.toJson(),
      'fare': fare,
    };
  }
}

enum BusStatus {
  inStation,
  operating,
  outOfService,
}
