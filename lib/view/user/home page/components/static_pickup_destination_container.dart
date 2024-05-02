import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/container/locationAddressRow.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/choose_on_map_provider.dart';

class StaticPickUpDestContainer extends StatefulWidget {
  final TextEditingController pickUpCtrl;
  final TextEditingController destinationCtrl;
  final double opacity;

  StaticPickUpDestContainer({
    super.key,
    this.opacity = 1,
    required this.pickUpCtrl,
    required this.destinationCtrl,
  });

  @override
  State<StaticPickUpDestContainer> createState() => _PickUpDestContainerState();
}

class _PickUpDestContainerState extends State<StaticPickUpDestContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChooseOnMapProvider>(
      builder: (context, ChooseOnMapProvider, _){
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
              SizedBox(height: 5.h),
              Visibility(
                visible: ChooseOnMapProvider.isSelected,
                child: TextButton(onPressed: (){
                  ChooseOnMapProvider.setIsSelectedToFalse();
                },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Choose on map",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.play_arrow_rounded,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                      ],
                    )),
              ),
              SizedBox(height: ChooseOnMapProvider.isSelected? 5.h: 10.h),

              /// static list of favourites addresses
              Visibility(
                visible: ChooseOnMapProvider.isSelected,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.r)),
                          color: AppColors.elevationOne,
                        ),
                        width: 360.w,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 25.0,top: 8.0, right: 25.0),
                              child: LocationAddressRow(
                                prefixIcon: Icons.home,
                                addressName: "EL Souk El Togary",
                                suffixIcon: Icons.edit_rounded,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 25.0,bottom: 8.0, right: 25.0),
                              child: LocationAddressRow(
                                prefixIcon: Icons.work_rounded,
                                addressName: "Valeo",
                                suffixIcon: Icons.edit_rounded,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /// Container 2
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        color: AppColors.elevationOne,
                      ),
                      width: 360.w,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25.0,top: 8.0, right: 25.0),
                            child: LocationAddressRow(
                              isThereAprefix: false,
                              addressName: "Cairo Festival City-New Cairo",
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: LocationAddressRow(
                              isThereAprefix: false,
                              addressName: "Valeo",
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: LocationAddressRow(
                              isThereAprefix: false,
                              addressName: "Valeo",
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 25.0,bottom: 8.0, right: 25.0),
                            child: LocationAddressRow(
                              isThereAprefix: false,
                              addressName: "Valeo",
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ChooseOnMapProvider.isSelected ? null : 10.h,
              ),
              Visibility(
                visible: !ChooseOnMapProvider.isSelected,
                child: AppTextField(
                  controller: widget.destinationCtrl,
                  hintText: 'Destination',
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
