import 'package:btt/model/entities/bus.dart';
import 'package:btt/model/entities/map_location.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/path_searching_utils.dart';

class PathDetailsSection extends StatefulWidget {
  final List<ViewablePath> viewablePath;
  final MapLocation startLocation;
  const PathDetailsSection({
    super.key,
    required this.viewablePath,
    required this.startLocation,
  });

  @override
  State<PathDetailsSection> createState() => _PathDetailsSectionState();
}

class _PathDetailsSectionState extends State<PathDetailsSection> {
  late final List<PathSection> pathSections;

  @override
  void initState() {
    super.initState();
    pathSections = [];
    for (final ViewablePath path in widget.viewablePath) {
      final Bus bus = path.bus;
      final MapLocation startLocation = path.stops.first;
      final MapLocation endLocation = path.stops.last;
      final int stops = path.stops.length;
      pathSections.add(PathSection(
        bus: bus,
        startLocation: startLocation,
        endLocation: endLocation,
        stops: stops,
        distance: startLocation.distanceToLocation(endLocation),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          for (final PathSection section in pathSections) ...[
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/bus.svg', height: 40.h),
                    16.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Take Bus ',
                            style: TextStyles.body,
                            children: [
                              TextSpan(
                                text: section.bus.identifier,
                                style: TextStyles.body.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        // distance
                        Text(
                          '${section.distance.toStringAsFixed(2)} km',
                          style: TextStyles.body.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '${PathSearchingUtils.getTravelDurationForPath(section.startLocation, section.endLocation).inMinutes} min',
                      style: TextStyles.body,
                    ),
                  ],
                ),
                16.verticalSpace,
                Row(
                  children: [
                    LocationNameContainer(name: section.startLocation.name),
                    Expanded(
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineThickness: 1.5,
                        dashLength: 4,
                        dashColor: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                    LocationNameContainer(name: section.endLocation.name),
                  ],
                ),
              ],
            ),
            if (section != pathSections.last) ...[
              Divider(height: 40.h),
            ],
          ]
        ],
      ),
    );
  }
}

class LocationNameContainer extends StatelessWidget {
  const LocationNameContainer({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      constraints: BoxConstraints(minWidth: 120.w, maxWidth: 150.w),
      child: Center(
        child: Text(
          name,
          style: TextStyles.body.copyWith(color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class PathSection {
  final Bus bus;
  final MapLocation startLocation;
  final MapLocation endLocation;
  final int stops;
  final double distance;

  PathSection({
    required this.bus,
    required this.startLocation,
    required this.endLocation,
    required this.stops,
    required this.distance,
  });
}
