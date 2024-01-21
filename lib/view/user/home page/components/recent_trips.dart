import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/misc/trip_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global/constants/text_styles.dart';

class RecentTripsContainer extends StatefulWidget {
  const RecentTripsContainer({super.key});

  @override
  State<RecentTripsContainer> createState() => _RecentTripsContainerState();
}

class _RecentTripsContainerState extends State<RecentTripsContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Recent Trips',
              style: TextStyles.title,
            ),
          ],
        ),
        5.verticalSpace,
        AspectRatio(
          aspectRatio: 1.62,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.darkElevation,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ASU - Faculty of Engineering',
                  style: TextStyles.title,
                ),
                Row(
                  children: [
                    Text(
                      'From: ',
                      style: TextStyles.body,
                    ),
                    Text(
                      'Dar Misr al Andalos',
                      style: TextStyles.bodyThin,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Time: ',
                      style: TextStyles.body,
                    ),
                    Text(
                      '1h 15m',
                      style: TextStyles.bodyThin,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Fare: ',
                      style: TextStyles.body,
                    ),
                    Text(
                      '20 L.E.',
                      style: TextStyles.bodyThin,
                    ),
                  ],
                ),
                20.verticalSpace,
                const TripBar(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
