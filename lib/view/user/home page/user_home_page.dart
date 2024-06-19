import 'package:btt/cache/cache_manager.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/user/home%20page/components/recent_trips.dart';
import 'package:btt/view/user/home%20page/components/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
    return Consumer<CacheManager>(builder: (context, cacheManager, _) {
      return Scaffold(
        extendBody: true,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.popAndPushNamed(context, '/SignIn');
                });
              },
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/MapSelector');
                  },
                  child: Hero(
                    tag: 'cont',
                    child: PickUpDestContainer(
                      pickUpCtrl: pickUpCtrl,
                      destinationCtrl: destinationCtrl,
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
    });
  }
}
