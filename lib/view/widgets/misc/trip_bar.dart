import 'package:btt/model/entities/traversed_route.dart';
import 'package:btt/view/widgets/misc/trip_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripBar extends StatefulWidget {
  const TripBar({super.key});
  @override
  State<TripBar> createState() => _TripBarState();
}

class _TripBarState extends State<TripBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: const AspectRatio(
        aspectRatio: 3.4,
        child: Row(
          children: [
            TripBarItem(
              routeType: RouteType.walk,
              time: '0:19',
              location: 'South 90st',
              flex: 1,
              order: ItemOrder.first,
            ),
            TripBarItem(
              routeType: RouteType.bus,
              time: '1:03',
              location: 'Al Abbaseya',
              flex: 2,
              order: ItemOrder.neither,
            ),
            TripBarItem(
              routeType: RouteType.metro,
              time: '1:12',
              location: 'Abdo Basha',
              flex: 3,
              order: ItemOrder.neither,
            ),
            TripBarItem(
              routeType: RouteType.walk,
              time: '1:15',
              location: 'ASU-Faculty of Engineering',
              flex: 1,
              order: ItemOrder.last,
            )
          ],
        ),
      ),
    );
  }
}

enum ItemOrder {
  first,
  last,
  neither,
}
