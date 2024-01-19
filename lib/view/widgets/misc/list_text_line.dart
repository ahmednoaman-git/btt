import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/constants/colors.dart';
import '../../global/constants/text_styles.dart';

class ListTextLine extends StatelessWidget {
  final String text;
  const ListTextLine({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: AppColors.secondaryText,
          size: 8.sp,
        ),
        5.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: TextStyles.smallBody,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
