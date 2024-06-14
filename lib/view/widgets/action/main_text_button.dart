import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class MainTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const MainTextButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text,
          style: TextStyles.body.copyWith(
            color: AppColors.accent1,
          )),
    );
  }
}
