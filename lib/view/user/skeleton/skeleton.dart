import 'package:btt/providers/pages_provider.dart';
import 'package:btt/view/widgets/input/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/favorites_provider.dart';
import '../../../providers/user_provider.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  @override
  void initState() {
    final userId = context.read<UserProvider>().user.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().fetchFavoriteLocations(userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PagesProvider>(builder: (context, pagesProviders, _) {
        return PageView(
          controller: pagesProviders.pageController,
          onPageChanged: pagesProviders.setIndexFromPageView,
          physics: const NeverScrollableScrollPhysics(),
          children: pagesProviders.pages,
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
