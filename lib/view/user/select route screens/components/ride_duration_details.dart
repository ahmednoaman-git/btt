import 'package:btt/view/user/select%20route%20screens/components/alternative_buses.dart';
import 'package:btt/view/user/select%20route%20screens/components/ride_duration_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/entities/traversed_route.dart';
import '../final_route_screen.dart';

class RideDurationDetails extends StatefulWidget {
  final RouteType routeType;
  final ItemOrder2 itemOrder;
  final String durationTitle;
  final String durationSubtitle;
  // final int flexValue;
  const RideDurationDetails({super.key,
    required this.routeType,
    required this.itemOrder,
    required this.durationTitle,
    required this.durationSubtitle,
    // required this.flexValue,
  });

  @override
  State<RideDurationDetails> createState() => _RideDurationDetailsState();
}

class _RideDurationDetailsState extends State<RideDurationDetails> {

  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 8.w,
                decoration: BoxDecoration(
                    gradient: getGradient(widget.routeType),
                    //borderRadius: BorderRadius.circular(20),
                    borderRadius: BorderRadius.vertical(
                      top: widget.itemOrder == ItemOrder2.first
                          ? Radius.circular(20.r)
                          : Radius.zero,
                      bottom: widget.itemOrder == ItemOrder2.last
                          ? Radius.circular(20.r)
                          : Radius.zero,
                    )
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: getIconForRouteType(widget.routeType, 34.sp),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8,),
                    RideDurationText(durationTitle: widget.durationTitle,
                      durationSubtitle: widget.durationSubtitle,),
                    if (_expanded && widget.routeType == RouteType.bus)...[
                      const AlternativeBuses(
                        alternativeBuses: ["M5", "GM9", "GM1", "NC1", "M5"],
                      ),
                      const SizedBox(height: 15,)
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}
enum ItemOrder2{
  first,
  last,
  normal;
}



