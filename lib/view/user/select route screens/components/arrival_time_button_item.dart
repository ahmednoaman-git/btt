import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/entities/traversed_route.dart';

class ArrivalTimeButton extends StatelessWidget {
  final String buttonDetails;
  final RouteType routeType;
  const ArrivalTimeButton({super.key,
    required this.buttonDetails,
    this.routeType = RouteType.bus,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: 35.r,
          width: 300.r,
          decoration: BoxDecoration(
          gradient: getGradient(routeType),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent),
          child: Text(buttonDetails,
            style: const TextStyle(color: Colors.white),
          ),

          ),
      ),
    );
  }
}
