import 'dart:async';

import 'package:btt/model/entities/traversed_route.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/user/select%20route%20screens/components/arrival_time_button_item.dart';
import 'package:btt/view/user/select%20route%20screens/components/dotted_separator_and_time.dart';
import 'package:btt/view/user/select%20route%20screens/components/ride_duration_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../widgets/input/location_selector.dart';
import '../home page/components/pickup_destination_container.dart';
import 'package:dotted_line/dotted_line.dart';

import 'components/ride_duration_details.dart';

class FinalRouteScreen extends StatefulWidget {
  const FinalRouteScreen({super.key});

  @override
  State<FinalRouteScreen> createState() => _FinalRouteScreenState();
}

class _FinalRouteScreenState extends State<FinalRouteScreen> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();
  final _locationController = Location();
  late final GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 0.9,
                child: LocationSelector(
                  onLocationSelected: (LatLng location) {
                    pickUpCtrl.text = location.toString();
                    // debugPrint(location.toString());
                  },
                  onControllerCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 70.h, horizontal: 21.w),
                  child: PickUpDestContainer(
                    opacity: 0.95,
                    pickUpCtrl: pickUpCtrl,
                    destinationCtrl: destinationCtrl,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          const Expanded(
           child: Column(
             children: [
               Expanded(
                 child: SingleChildScrollView(
                   child: Column(
                      children: [
                        RideDurationDetails(
                          routeType: RouteType.walk,
                         // containerColor: Colors.white,
                          durationTitle: "Walk for 19 minutes to South 90st",
                          durationSubtitle: "Distance: 1.35km",
                          // flexValue: 1,
                          itemOrder: ItemOrder2.first,
                        ),
                        DottedSeparatorAndTime(timeDetails: "10:00 AM"),
                        RideDurationDetails( routeType: RouteType.bus,
                         // containerColor: Colors.white,
                          durationTitle: "Take bus 1062 to AL-Abbaseya"  ,
                          durationSubtitle: "Distance: 14.53km",
                          // flexValue: 2,
                          itemOrder: ItemOrder2.normal,
                        ),
                        DottedSeparatorAndTime(timeDetails: "10:44 AM"),
                        RideDurationDetails( routeType: RouteType.metro,
                          //containerColor: Colors.white,
                          durationTitle: "Take the metro to Abdo Basha",
                          durationSubtitle: "Distance:  1.67km",
                          // flexValue: 3,
                          itemOrder: ItemOrder2.normal,
                        ),
                        DottedSeparatorAndTime(timeDetails: "11:00 AM"),
                        RideDurationDetails(
                          routeType: RouteType.walk,
                          // containerColor: Colors.white,
                          durationTitle: "Walk 3 minutes to Faculty of Engineering Ain Sahms University",
                          durationSubtitle: "Distance: 1.00km",
                          // flexValue: 1,
                          itemOrder: ItemOrder2.last,
                        ),
                      ],
                    ),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(20.0),
                 child: ArrivalTimeButton(buttonDetails: "Go - Arrive at 10:56 AM"),
               ),
             ],
           ),
          )
        ],
      ),
    );
  }
}
