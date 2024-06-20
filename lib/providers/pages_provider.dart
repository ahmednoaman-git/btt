import 'package:btt/view/user/favorites%20page/favorites.dart';
import 'package:btt/view/user/home%20page/user_home_page.dart';
import 'package:btt/view/user/profile%20page/profile.dart';
import 'package:btt/view/user/recents%20page/recents.dart';
import 'package:flutter/material.dart';

class PagesProvider extends ChangeNotifier {
  List<Widget> pages = [
    const UserHomePage(),
    const FavoritesPage(),
    const RecentsPage(),
    const ProfilePage(),
  ];
  int currentIndex = 0;
  final PageController pageController = PageController();

  void setIndex(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void setIndexFromPageView(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void reset() {
    currentIndex = 0;
    pageController.jumpToPage(0);
    notifyListeners();
  }
}
