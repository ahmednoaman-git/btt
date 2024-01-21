import 'package:btt/model/entities/traversed_route.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/misc/trip_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripBarItem extends StatefulWidget {
  final RouteType routeType;
  final String time;
  final String location;
  final int flex;
  final ItemOrder order;
  const TripBarItem({
    super.key,
    required this.routeType,
    required this.time,
    required this.location,
    required this.flex,
    required this.order,
  });

  @override
  State<TripBarItem> createState() => _TripBarItemState();
}

class _TripBarItemState extends State<TripBarItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getIconForRouteType(widget.routeType),
                  ],
                ),
                5.verticalSpace,
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: widget.order == ItemOrder.first ? Radius.circular(20.r) : Radius.zero,
                      right: widget.order == ItemOrder.last ? Radius.circular(20.r) : Radius.zero,
                    ),
                    gradient: getGradient(widget.routeType),
                  ),
                ),
                Text(
                  widget.time,
                  style: TextStyles.smallBody.apply(fontSizeDelta: -1),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  child: Text(
                    widget.location,
                    style: TextStyles.smallBody.apply(fontSizeDelta: -3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          (widget.order != ItemOrder.last)
              ? Row(
                  children: [
                    1.5.horizontalSpace,
                    const DottedLine(
                      direction: Axis.vertical,
                      dashColor: Colors.white,
                      lineThickness: 0.7,
                    ),
                    1.5.horizontalSpace,
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
