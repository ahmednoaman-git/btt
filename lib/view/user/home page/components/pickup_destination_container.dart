import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickUpDestContainer extends StatefulWidget {
  final TextEditingController pickUpCtrl;
  final TextEditingController destinationCtrl;
  final double opacity;
  const PickUpDestContainer({
    super.key,
    this.opacity = 1,
    required this.pickUpCtrl,
    required this.destinationCtrl,
  });

  @override
  State<PickUpDestContainer> createState() => _PickUpDestContainerState();
}

class _PickUpDestContainerState extends State<PickUpDestContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: AppColors.darkElevation.withOpacity(widget.opacity),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: widget.pickUpCtrl,
            hintText: 'Current Location',
            prefixIcon: const Icon(Icons.location_on),
          ),
          SizedBox(height: 22.h),
          AppTextField(
            controller: widget.destinationCtrl,
            hintText: 'Destination',
            prefixIcon: const Icon(Icons.search_rounded),
          )
        ],
      ),
    );
  }
}
