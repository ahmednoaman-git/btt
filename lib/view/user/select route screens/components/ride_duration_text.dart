import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global/constants/colors.dart';

class RideDurationText extends StatelessWidget {
  final String durationTitle;
  final String durationSubtitle;
  const RideDurationText(
      {super.key,
    required this.durationTitle,
    required this.durationSubtitle}
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(durationTitle,
            style: TextStyle(
              fontSize: 16.sp,
             // fontWeight: FontWeight.w500,
              color: AppColors.text,
            overflow: TextOverflow.ellipsis,
            ),
          maxLines: 2,
        ),
        Text(durationSubtitle,
          style: TextStyle(
            fontSize: 13.sp,
            //fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
              overflow: TextOverflow.ellipsis,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}
