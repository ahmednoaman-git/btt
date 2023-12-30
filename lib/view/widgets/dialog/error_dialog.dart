import 'package:btt/view/global/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.r),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/error.json',
                height: 30.h,
                fit: BoxFit.cover,
                repeat: false,
                frameRate: FrameRate(90),
              ),
              Text(
                title,
                style: TextStyles.body,
              ),
            ],
          ),
          5.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 7.w),
            child: Text(
              message,
              style: TextStyles.smallBodyThin,
            ),
          ),
        ],
      ),
    );
  }
}
