import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/misc/list_text_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';

class UsualBusContainer extends StatefulWidget {
  const UsualBusContainer({super.key});

  @override
  State<UsualBusContainer> createState() => _UsualBusContainerState();
}

class _UsualBusContainerState extends State<UsualBusContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Usual Bus',
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
                busStatusContainer(),
                15.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const ListTextLine(
                          text: 'Al Abbaseya Square',
                        ),
                        5.verticalSpace,
                        const ListTextLine(
                          text: 'Ramses',
                        ),
                        5.verticalSpace,
                        const ListTextLine(
                          text: 'The American University',
                        ),
                        5.verticalSpace,
                        const ListTextLine(
                          text: 'Tahrir Square',
                        ),
                        5.verticalSpace,
                        const ListTextLine(
                          text: 'Tahrir Square',
                        ),
                        5.verticalSpace,
                        const ListTextLine(
                          text: 'Tahrir Square',
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                MainButton(
                  text: 'Track',
                  hollow: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  icon: Icon(
                    Icons.location_on_rounded,
                    color: AppColors.text,
                    size: 17.sp,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget busStatusContainer() {
    return AspectRatio(
      aspectRatio: 2.22,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4.h),
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(20.r),
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.7,
            colors: [
              AppColors.accent1.withOpacity(0.45),
              AppColors.accent2.withOpacity(0.12),
              AppColors.accent1.withOpacity(0.05),
            ],
            stops: const [0, 0.5, 1],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1062',
                    style: TextStyles.largeTitle,
                  ),
                  Text(
                    '4 In Service',
                    style: TextStyles.smallBody,
                  ),
                ],
              ),
              GradientCircularProgressIndicator(
                progress: 0.6,
                stroke: 6,
                gradient: const LinearGradient(
                  colors: [AppColors.accent1, AppColors.accent2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                backgroundColor: Colors.transparent,
                size: 50.sp,
                child: Center(
                  child: Text(
                    '7:41',
                    style: TextStyles.body,
                  ),
                ), // Optional child widget
              )
            ],
          ),
        ),
      ),
    );
  }
}
