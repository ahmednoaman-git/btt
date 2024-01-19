import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_icon/gradient_icon.dart';

import '../../global/constants/colors.dart';
import '../../global/constants/text_styles.dart';

class ListTextFav extends StatelessWidget {
  final String text;
  const ListTextFav({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyles.body.apply(color: AppColors.secondaryText),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        10.horizontalSpace,
        const GradientIcon(
          offset: Offset(0, 0),
          icon: Icons.star_rounded,
          gradient: LinearGradient(
              colors: [AppColors.accent1, AppColors.accent2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.05, 1]),
        ),
      ],
    );
  }
}
