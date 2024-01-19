import 'package:btt/view/global/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_icon/gradient_icon.dart';

class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;
  const SocialMediaButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: AppColors.elevationOne,
        ),
        child: GradientIcon(
            size: 30.sp,
            offset: const Offset(0, 0),
            icon: icon,
            gradient: const LinearGradient(
              colors: [
                AppColors.accent1,
                AppColors.accent2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1],
            )),
      ),
    );
  }
}
