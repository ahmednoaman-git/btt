import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../global/constants/colors.dart';

class LocationAddressRow extends StatelessWidget {
  final String addressName;
  final IconData? prefixIcon;
  final IconData suffixIcon;
  final bool isThereAprefix;
  final Color textColor;

  const LocationAddressRow({
    super.key,
    this.suffixIcon = Icons.play_arrow_rounded,
    required this.addressName,
    this.prefixIcon,
    this.isThereAprefix = true,
    this.textColor = AppColors.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [

          if (isThereAprefix)
                  ...[Icon(prefixIcon, color: Colors.white,),
                  SizedBox(
                    width: 10.w,
                  ),]
          else
           SizedBox(
             width: 7.w,
           ),


          Text(
            addressName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(suffixIcon, color: Colors.white,),
        ],
      );
  }
}
