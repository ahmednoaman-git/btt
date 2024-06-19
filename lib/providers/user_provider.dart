import 'package:btt/model/entities/app_user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late final AppUser user;

  void setUser(AppUser user) {
    user = user;
    notifyListeners();
  }
}
