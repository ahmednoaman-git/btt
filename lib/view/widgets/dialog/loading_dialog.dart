import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool? showCancelAfterDelay;
  const LoadingDialog({super.key, required this.title, required this.message, this.showCancelAfterDelay = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 13.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 15.w,
                height: 15.w,
                child: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.accent1, AppColors.accent2],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: CircularProgressIndicator(color: AppColors.accent1, strokeWidth: 2.w),
                ),
              ),
              SizedBox(width: 10.w),
              Text(title),
            ],
          ),
          SizedBox(height: 10.h),
          Text(message, style: TextStyles.smallBodyThin),
        ],
      ),
    );
  }
}
