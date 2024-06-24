import 'package:btt/view/user/home%20page/user_home_page.dart';
import 'package:btt/view/user/profile%20page/profile.dart';
import 'package:btt/view/user/search_screen.dart';
import 'package:flutter/material.dart';

import '../view/user/live track page/live_track_page.dart';

class PagesProvider extends ChangeNotifier {
  List<Widget> pages = [
    const UserHomePage(),
    const SearchScreen(),
    const LiveTrackPage(),
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
