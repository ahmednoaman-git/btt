import 'package:btt/services/bus_services.dart';
import 'package:btt/view/widgets/api/request_widget.dart';
import 'package:btt/view/widgets/misc/bus_tile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/entities/bus.dart';
import '../../../../tools/response.dart';
import '../../../global/constants/colors.dart';
import '../../../global/constants/text_styles.dart';
import '../../../widgets/action/main_button.dart';

class AllBuses extends StatefulWidget {
  const AllBuses({super.key});

  @override
  State<AllBuses> createState() => _AllBusesState();
}

class _AllBusesState extends State<AllBuses> {
  late final Future<Response<List<Bus>>> allBuses;

  @override
  void initState() {
    allBuses = BusServices.getBuses();
    super.initState();
  }

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
                  child: RequestWidget(
                      request: allBuses,
                      successWidgetBuilder: (data) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return BusTileButton(bus: data[index]);
                          },
                          separatorBuilder: (_, index) {
                            return 10.verticalSpace;
                          },
                          itemCount: data.length,
                        );
                      }),
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
