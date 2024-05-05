import 'package:btt/view/global/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_icon/gradient_icon.dart';

class TraversedRoute {
  String id;
  double startLatitude;
  double startLongitude;
  double endLatitude;
  double endLongitude;
  DateTime startTime;
  DateTime endTime;
  double distance; // In meters
  double fare; // In EGP
  RouteType type;
  String vehicleId;

  TraversedRoute({
    required this.id,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.fare,
    required this.type,
    required this.vehicleId,
  });

  factory TraversedRoute.fromJson(Map<String, dynamic> json) {
    return TraversedRoute(
      id: json['id'],
      startLatitude: json['startLatitude'],
      startLongitude: json['startLongitude'],
      endLatitude: json['endLatitude'],
      endLongitude: json['endLongitude'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      distance: json['distance'],
      fare: json['fare'],
      type: RouteType.values[json['type']],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'fare': fare,
      'type': type.index,
      'vehicleId': vehicleId,
    };
  }
}

enum RouteType {
  bus,
  metro,
  walk,
}

GradientIcon getIconForRouteType(RouteType type, double iconSize) {
  switch (type) {
    case RouteType.bus:
      return GradientIcon(
        offset: const Offset(0, 0),
        icon: Icons.directions_bus_rounded,
        size: iconSize,
        gradient: getGradient(RouteType.bus),
      );
    case RouteType.metro:
      return GradientIcon(
        offset: const Offset(0, 0),
        size: iconSize,
        gradient: getGradient(RouteType.metro),
        icon: Icons.train_rounded,
      );
    case RouteType.walk:
      return GradientIcon(
        offset: const Offset(0, 0),
        icon: Icons.directions_walk,
        size: iconSize,
        gradient: getGradient(RouteType.walk),
      );
    default:
      return GradientIcon(
        offset: const Offset(0, 0),
        icon: Icons.directions_walk,
        size: iconSize,
        gradient: getGradient(RouteType.walk),
      );
  }
}

Gradient getGradient(RouteType routeType) {
  switch (routeType) {
    case RouteType.walk:
      return const LinearGradient(
        colors: [
          Colors.white,
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 0.7],
      );
    case RouteType.bus:
      return const LinearGradient(
        colors: [
          AppColors.accent1,
          AppColors.accent2,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 0.7],
      );
    case RouteType.metro:
      return const LinearGradient(
        colors: [
          Color(0xFF2A803D),
          Color(0xFF74B883),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 0.7],
      );
  }
}
