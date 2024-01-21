import 'package:btt/model/entities/map_location.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/misc/mini_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationSelectionTile extends StatelessWidget {
  final bool isSelected;
  final MapLocation location;
  final void Function() onTap;
  const LocationSelectionTile(
      {super.key, required this.isSelected, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 750.ms,
      curve: Curves.easeOutExpo,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: isSelected ? AppColors.accent1 : AppColors.secondaryText,
          width: 2.w,
        ),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27.r),
        ),
        child: Material(
          color: isSelected ? AppColors.accent1.withOpacity(0.1) : AppColors.darkElevation,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          location.name,
                          style: TextStyles.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: SizedBox(
                      width: double.infinity,
                      child: MiniMap(
                        aspectRatio: 1.5,
                        latitude: location.latitude,
                        longitude: location.longitude,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
