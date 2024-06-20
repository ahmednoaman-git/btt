import 'package:btt/providers/pages_provider.dart';
import 'package:btt/providers/user_provider.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../global/constants/text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyles.largeTitle,
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, _) {
        List<String> words = userProvider.user.name.trim().split(' ');
        String initials;
        if (words.length > 1) {
          initials = words.first.substring(0, 1).toUpperCase() + words.last.substring(0, 1).toUpperCase();
        } else {
          initials = words.first.substring(0, 1).toUpperCase();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accent1,
                      radius: 45.r,
                      child: Text(
                        initials,
                        style: TextStyles.title,
                      ),
                    ),
                    15.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userProvider.user.name, style: TextStyles.body.apply(fontWeightDelta: 1)),
                        Text(userProvider.user.email, style: TextStyles.bodyThin),
                      ],
                    )
                  ],
                ),
                16.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      splashColor: AppColors.red.withOpacity(0.5),
                      onTap: () {
                        context.read<PagesProvider>().reset();
                        FirebaseAuth.instance.signOut().then((_) {
                          Navigator.popAndPushNamed(context, '/SignIn');
                        });
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.red,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyles.body,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
