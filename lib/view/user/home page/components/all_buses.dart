import 'package:btt/view/widgets/misc/bus_tile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/entities/bus.dart';
import '../../../global/constants/colors.dart';
import '../../../global/constants/text_styles.dart';
import '../../../widgets/action/main_button.dart';

class AllBuses extends StatefulWidget {
  const AllBuses({super.key});

  @override
  State<AllBuses> createState() => _AllBusesState();
}

class _AllBusesState extends State<AllBuses> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'All Buses',
              style: TextStyles.title,
            ),
          ],
        ),
        5.verticalSpace,
        Expanded(
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.darkElevation,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BusTileButton(bus: Bus.emptyBus()),
                        10.verticalSpace,
                        BusTileButton(bus: Bus.emptyBus()),
                        10.verticalSpace,
                        BusTileButton(bus: Bus.emptyBus()),
                        10.verticalSpace,
                        BusTileButton(bus: Bus.emptyBus()),
                        10.verticalSpace,
                        BusTileButton(bus: Bus.emptyBus()),
                        10.verticalSpace,
                        BusTileButton(bus: Bus.emptyBus()),
                        10.verticalSpace,
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                MainButton(
                  text: 'More...',
                  hollow: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  onPressed: () {},
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
