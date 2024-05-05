import 'package:btt/view/global/constants/colors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DottedSeparatorAndTime extends StatelessWidget {
  final String timeDetails;
  const DottedSeparatorAndTime(
      {super.key, required this.timeDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
        height: 3,
        clipBehavior: Clip.none,

        child: Stack(
            clipBehavior: Clip.none,
          children: [
            const Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: DottedLine(
                      // direction: Axis.horizontal,
                      dashColor: Colors.white,
                      lineThickness: 0.7,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
                top: -8,
                child: Row(
                  children: [
                    const Text("Time: ",
                      style: TextStyle(color: Colors.white,
                          fontSize: 13),),
                    Text(timeDetails,
                      style: const TextStyle(color: AppColors.secondaryText,
                      fontSize: 13),
                        ),
                  ],
                )),
          ]
        ),
      ),
    );
  }
}
