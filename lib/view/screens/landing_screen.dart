import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/entities/app_user.dart';
import '../../providers/user_provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool userSignedIn = false;

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserProvider>().setUser(
              AppUser(
                id: user.uid,
                name: user.displayName!,
                email: user.email!,
              ),
            );
      });
      userSignedIn = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (userSignedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popAndPushNamed('/UserHome');
            });
            return const SizedBox.shrink();
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popAndPushNamed('/Signup');
            });
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
