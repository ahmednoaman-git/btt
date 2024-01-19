import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final void Function()? onPressed;
  final bool shrinkWrap;
  final bool hollow;
  final bool loading;
  final EdgeInsets? padding;
  const MainButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.shrinkWrap = false,
    this.hollow = false,
    this.loading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (hollow) {
      return OutlineGradientButton(
        onTap: onPressed,
        elevation: 0,
        radius: Radius.circular(100.r),
        strokeWidth: 2.w,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: shrinkWrap ? 0 : 15.9.h,
              horizontal: shrinkWrap ? 20.w : 0.w,
            ),
        inkWell: true,
        gradient: LinearGradient(
          colors: onPressed == null
              ? [
                  AppColors.secondaryText,
                  AppColors.secondaryText,
                ]
              : [
                  AppColors.accent1,
                  AppColors.accent2,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.7],
        ),
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicHeight(
                    child: SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.text,
                          strokeWidth: 2.w,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) SizedBox(width: 10.w),
                  Text(
                    text,
                    style: TextStyles.button,
                  ),
                ],
              ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        gradient: const LinearGradient(
          colors: [
            AppColors.accent1,
            AppColors.accent2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.7],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          padding: EdgeInsets.symmetric(
            vertical: shrinkWrap ? 0 : 15.h,
            horizontal: shrinkWrap ? 20.w : 0.w,
          ),
        ),
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicHeight(
                    child: SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.text,
                          strokeWidth: 2.w,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) SizedBox(width: 10.w),
                  Text(
                    text,
                    style: TextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}
