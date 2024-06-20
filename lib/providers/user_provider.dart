import 'package:btt/model/entities/app_user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late AppUser user;

  void setUser(AppUser appUser) {
    user = appUser;
    notifyListeners();
  }
}
