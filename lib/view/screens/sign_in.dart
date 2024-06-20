import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:btt/view/widgets/misc/social_media_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:provider/provider.dart';

import '../../model/entities/app_user.dart';
import '../../providers/user_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 150.h),
        child: SingleChildScrollView(
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.darkElevation,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyles.large,
                      ),
                    ],
                  ),
                  35.verticalSpace,
                  AppTextField(
                    controller: emailCtrl,
                    hintText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                      color: AppColors.text,
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'required';
                      }
                      return null;
                    },
                  ),
                  30.verticalSpace,
                  AppTextField(
                      controller: passCtrl,
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock_rounded,
                        color: AppColors.text,
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 'required';
                        }
                        return null;
                      }),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyles.body.apply(
                          color: AppColors.secondaryText,
                          fontWeightDelta: -1,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.secondaryText,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_right,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                  35.verticalSpace,
                  SizedBox(
                    width: 200.w,
                    child: MainButton(
                      text: 'Sign in',
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      onPressed: () {
                        {
                          if (!formKey.currentState!.validate()) return;
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailCtrl.text,
                            password: passCtrl.text,
                          )
                              .then((userCredentials) {
                            context.read<UserProvider>().setUser(
                                  AppUser(
                                    id: userCredentials.user!.uid,
                                    name: userCredentials.user!.displayName!,
                                    email: userCredentials.user!.email!,
                                  ),
                                );
                            Navigator.of(context).pushNamed('/Skeleton');
                          }).onError((error, _) {
                            debugPrint(error.toString());
                          });
                        }
                      },
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OR',
                        style: TextStyles.title.apply(
                          color: AppColors.secondaryText,
                          fontSizeDelta: -4,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Container(
                    width: 230.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryText,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  20.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SocialMediaButton(
                          icon: Icons.facebook_rounded,
                          onPressed: () {},
                        ),
                        SocialMediaButton(
                          icon: Icons.apple_rounded,
                          onPressed: () {},
                        ),
                        SocialMediaButton(
                          icon: Icons.phone_rounded,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  35.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GradientIcon(
                        offset: const Offset(0, 0),
                        size: 50.sp,
                        icon: Icons.directions_bus_rounded,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accent1,
                            AppColors.accent2,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.5, 1],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 1.w,
                              decoration: const BoxDecoration(
                                color: AppColors.text,
                              ),
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Text(
                                'Get the fastest, cheapest routes in Cairo with the click of a button.',
                                style: TextStyles.smallBody,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
