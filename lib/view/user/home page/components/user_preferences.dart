import 'package:btt/view/user/home%20page/components/all_buses.dart';
import 'package:btt/view/user/home%20page/components/location_favorites.dart';
import 'package:btt/view/user/home%20page/components/usual_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserPreferences extends StatefulWidget {
  const UserPreferences({super.key});

  @override
  State<UserPreferences> createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const AspectRatio(aspectRatio: 2 / 3, child: UsualBusContainer()),
          17.horizontalSpace,
          const AspectRatio(aspectRatio: 2 / 3, child: LocationFavoritesContainer()),
          17.horizontalSpace,
          const AspectRatio(aspectRatio: 2 / 3, child: AllBuses()),
        ],
      ),
    );
  }
}
