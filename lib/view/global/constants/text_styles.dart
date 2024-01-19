import 'package:btt/view/global/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle large = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle largeTitle = TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle title = TextStyle(
    fontSize: 21.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static TextStyle subtitle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );
  static TextStyle bodyThin = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  static TextStyle smallBody = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryText,
  );

  static TextStyle smallBodyThin = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.secondaryText,
  );

  static TextStyle tiny = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.secondaryText,
  );

  static TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
}
