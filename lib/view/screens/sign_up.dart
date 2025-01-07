import 'package:btt/functions/validators.dart';
import 'package:btt/model/entities/app_user.dart';
import 'package:btt/providers/user_provider.dart';
import 'package:btt/services/user_services.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:btt/view/widgets/misc/social_media_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../global/constants/text_styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCTRL = TextEditingController();
  final TextEditingController emailCTRL = TextEditingController();
  final TextEditingController passwordCTRL = TextEditingController();
  final TextEditingController confPasswordCTRL = TextEditingController();
  final TextEditingController phoneCTRL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 35.w, right: 35.w, top: 120.h),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            decoration: BoxDecoration(
              color: AppColors.darkElevation,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign up",
                      style: TextStyles.large,
                    ),
                  ],
                ),
                20.verticalSpace,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: nameCTRL,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.text,
                        ),
                        hintText: 'Name',
                        validator: Validators.nameValidator,
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: emailCTRL,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColors.text,
                        ),
                        hintText: 'Email',
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: passwordCTRL,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.text,
                        ),
                        hintText: 'Password',
                        validator: Validators.passwordValidator,
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: confPasswordCTRL,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.text,
                        ),
                        hintText: 'Confirm Password',
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Confirmation required';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: phoneCTRL,
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: AppColors.text,
                        ),
                        hintText: 'Mobile Number',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Mobile Number is required';
                          }
                          return null;
                        },
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyles.body.apply(
                              color: AppColors.secondaryText,
                              fontWeightDelta: -1,
                              decorationColor: AppColors.secondaryText,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/SignIn');
                            },
                            child: const Text(
                              'Sign In',
                            ),
                          )
                        ],
                      ),
                      20.verticalSpace,
                      SizedBox(
                        width: 200.w,
                        child: MainButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            if (passwordCTRL.text != confPasswordCTRL.text) {
                              debugPrint('Passwords are not the same..');
                              return;
                            }
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailCTRL.text,
                              password: passwordCTRL.text,
                            )
                                .then((userCredentials) {
                              userCredentials.user!.updateDisplayName(nameCTRL.text);
                              UserServices.createUser(userCredentials.user!.uid);
                              context.read<UserProvider>().setUser(
                                    AppUser(
                                      id: userCredentials.user!.uid,
                                      name: nameCTRL.text,
                                      email: userCredentials.user!.email!,
                                    ),
                                  );
                              Navigator.of(context).pushNamed('/Skeleton');
                            }).onError((error, _) {
                              debugPrint(error.toString());
                            });
                          },
                          text: "Submit",
                        ),
                      ),
                      15.verticalSpace,
                      Text(
                        "OR",
                        style: TextStyles.title.apply(
                          color: AppColors.secondaryText,
                          fontSizeDelta: -4,
                        ),
                      ),
                      15.verticalSpace,
                      Container(
                          height: 0.5.h,
                          width: 215.w,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryText,
                            borderRadius: BorderRadius.circular(10.r),
                          )),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
