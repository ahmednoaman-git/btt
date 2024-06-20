import 'package:btt/providers/pages_provider.dart';
import 'package:btt/view/widgets/input/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PagesProvider>(builder: (context, pagesProviders, _) {
        return PageView(
          controller: pagesProviders.pageController,
          onPageChanged: pagesProviders.setIndexFromPageView,
          children: pagesProviders.pages,
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
