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
                  child: Icon(Icons.home_filled),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.search_rounded),
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.route_rounded),
                ),
                label: 'Track',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.person),
                ),
                label: 'Profile',
              )
            ],
          ),
        ),
      );
    });
  }
}
