import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/user/home%20page/components/recent_trips.dart';
import 'package:btt/view/user/home%20page/components/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/pickup_destination_container.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  TextEditingController pickUpCtrl = TextEditingController();
  TextEditingController destinationCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.text,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              /// endpoint: https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/MapSelector');
                },
                child: Hero(
                  tag: 'cont',
                  child: Material(
                    color: Colors.transparent,
                    child: PickUpDestContainer(
                      pickUpCtrl: pickUpCtrl,
                      destinationCtrl: destinationCtrl,
                    ),
                  ),
                ),
              ),
              20.verticalSpace,
              const AspectRatio(
                aspectRatio: 7 / 5,
                child: UserPreferences(),
              ),
              20.verticalSpace,
              const RecentTripsContainer()
            ],
          ),
        ),
      ),
    );
  }
}
