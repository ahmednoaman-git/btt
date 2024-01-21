import 'package:btt/model/entities/bus.dart';
import 'package:btt/view/user/Bus%20Route%20Screen/bus_route_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_icon/gradient_icon.dart';

import '../../global/constants/colors.dart';
import '../../global/constants/text_styles.dart';

class BusTileButton extends StatelessWidget {
  final Bus bus;
  const BusTileButton({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BusRouteScreen(bus: bus)),
        );
      },
      child: Row(
        children: [
          const GradientIcon(
              offset: Offset(0, 0),
              icon: Icons.directions_bus_filled_rounded,
              gradient: LinearGradient(
                  colors: [AppColors.accent1, AppColors.accent2],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.05, 1])),
          10.horizontalSpace,
          Expanded(
            child: Text(
              bus.identifier,
              style: TextStyles.body.apply(color: AppColors.secondaryText),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
