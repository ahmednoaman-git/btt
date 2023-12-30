import 'package:animated_check/animated_check.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDialog extends StatefulWidget {
  final String title;
  final String? message;
  final bool? enableLoader;
  final bool? showOk;
  const SuccessDialog({super.key, required this.title, this.message, this.enableLoader, this.showOk});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final Curve _animationCurve = Curves.easeOutExpo;
  final double _bubbleRadius = 7.5.r;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: _animationCurve));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.sp),
              CircleAvatar(
                radius: _bubbleRadius,
                backgroundColor: AppColors.green,
                child: SizedBox(
                  width: _bubbleRadius * 1.6,
                  height: _bubbleRadius * 1.6,
                  child: AnimatedCheck(
                    color: AppColors.elevationOne,
                    progress: _animation,
                    size: _bubbleRadius * 1.6,
                    strokeWidth: 1.2.w,
                  ),
                ),
              )
                  .animate()
                  .then(delay: 800.ms)
                  .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), curve: _animationCurve, duration: 750.ms)
                  .then()
                  .scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
              10.horizontalSpace,
              Text(widget.title, style: TextStyles.body, textAlign: TextAlign.center),
            ],
          ),
          10.verticalSpace,
          if (widget.message != null && (widget.enableLoader ?? false))
            Row(
              children: [
                Text(widget.message!, style: TextStyles.smallBodyThin.apply(fontSizeFactor: 0.8), textAlign: TextAlign.center),
                SizedBox(width: 6.w),
                SizedBox(
                  width: 10.w,
                  height: 10.w,
                  child: CircularProgressIndicator(color: AppColors.accent1, strokeWidth: 2.w),
                ),
              ],
            ),
          if (widget.message != null && !(widget.enableLoader ?? false)) Text(widget.message!, style: TextStyles.smallBodyThin),
        ],
      ),
    );
  }
}
