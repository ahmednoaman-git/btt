import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickUpDestContainer extends StatefulWidget {
  const PickUpDestContainer({super.key});

  @override
  State<PickUpDestContainer> createState() => _PickUpDestContainerState();
}

class _PickUpDestContainerState extends State<PickUpDestContainer> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: AppColors.darkElevation,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextField(
            controller: pickUpCtrl,
            hintText: 'Current Location',
            prefixIcon: const Icon(Icons.location_on),
          ),
          AppTextField(
            controller: destinationCtrl,
            hintText: 'Destination',
            prefixIcon: const Icon(Icons.search_rounded),
          )
        ],
      ),
    );
  }
}
