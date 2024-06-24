import 'package:btt/model/entities/bus.dart';
import 'package:btt/model/entities/map_location.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/user/view_lookup_path.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/path_searching_utils.dart';

class PathDetailsSection extends StatefulWidget {
  final List<ViewablePath> viewablePath;
  final WalkPath startWalkPath;
  final MapLocation startLocation;
  final WalkPath endWalkPath;
  const PathDetailsSection({
    super.key,
    required this.viewablePath,
    required this.startWalkPath,
    required this.startLocation,
    required this.endWalkPath,
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
          _stepTile(
            false,
            true,
            '',
            widget.startWalkPath.duration.inMinutes.toString(),
            widget.startWalkPath.distance,
            'Start',
            pathSections.first.startLocation.name,
          ),
          if (pathSections.isNotEmpty) ...[
            Divider(height: 40.h),
          ],
          for (final PathSection section in pathSections) ...[
            _stepTile(
              true,
              false,
              section.bus.identifier,
              PathSearchingUtils.getTravelDurationForPath(section.startLocation, section.endLocation).inMinutes.toString(),
              section.distance,
              section.startLocation.name,
              section.endLocation.name,
            ),
            if (section != pathSections.last) ...[
              Divider(height: 40.h),
            ],
          ],
          Divider(height: 40.h),
          _stepTile(
            false,
            false,
            '',
            widget.endWalkPath.duration.inMinutes.toString(),
            widget.endWalkPath.distance,
            pathSections.last.endLocation.name,
            'End',
          ),
        ],
      ),
    );
  }

  Widget _stepTile(bool isBus, bool isStartWalk, String busTitle, String duration, double distance, String startName, String endName) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/${isBus ? 'bus' : 'icons/person'}.svg', height: 40.h),
            16.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Take ${isBus ? 'Bus' : 'a walk to'} ',
                    style: TextStyles.body,
                    children: [
                      TextSpan(
                        text: isBus ? busTitle : (isStartWalk ? endName : startName),
                        style: TextStyles.body.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                // distance
                Text(
                  '${distance.toStringAsFixed(2)} km',
                  style: TextStyles.body.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Text(
              //PathSearchingUtils.getTravelDurationForPath(section.startLocation, section.endLocation).inMinutes}
              '$duration min',
              style: TextStyles.body,
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            LocationNameContainer(name: startName),
            Expanded(
              child: DottedLine(
                direction: Axis.horizontal,
                lineThickness: 1.5,
                dashLength: 4,
                dashColor: Colors.grey.withOpacity(0.1),
              ),
            ),
            LocationNameContainer(name: endName),
          ],
        ),
      ],
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
