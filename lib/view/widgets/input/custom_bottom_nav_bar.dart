import 'package:btt/providers/pages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global/constants/colors.dart';
import '../../global/constants/text_styles.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;
  final List<String> _navigationPaths = ['dashboard', 'requests', 'time-off', 'settings'];
  @override
  Widget build(BuildContext context) {
    return Consumer<PagesProvider>(builder: (context, pagesProvider, _) {
      return SizedBox(
        height: 70,
        child: Theme(
          data: ThemeData(splashColor: AppColors.grey.withOpacity(0.5)),
          child: BottomNavigationBar(
            unselectedLabelStyle: TextStyles.tiny500,
            selectedLabelStyle: TextStyles.tiny500Accent1,
            selectedItemColor: AppColors.accent1,
            unselectedItemColor: AppColors.secondaryText,
            backgroundColor: AppColors.background,
            type: BottomNavigationBarType.fixed,
            currentIndex: pagesProvider.currentIndex,
            onTap: (index) {
              pagesProvider.setIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.route),
                ),
                label: 'Trip',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.favorite_border_rounded),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.favorite_rounded),
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.access_time_rounded),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.access_time_filled_rounded),
                ),
                label: 'Recents',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.person_outline_rounded),
                ),
                activeIcon: Padding(padding: EdgeInsets.only(bottom: 5), child: Icon(Icons.person)),
                label: 'Profile',
              )
            ],
          ),
        ),
      );
    });
  }
}
