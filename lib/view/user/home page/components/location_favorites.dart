import 'package:btt/providers/favorites_provider.dart';
import 'package:btt/view/widgets/misc/list_text_fav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../global/constants/colors.dart';
import '../../../global/constants/text_styles.dart';
import '../../../widgets/action/main_button.dart';

class LocationFavoritesContainer extends StatelessWidget {
  const LocationFavoritesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> favorites = context.watch<FavoritesProvider>().favoriteLocations.map((location) => location.name).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Favorites',
              style: TextStyles.title,
            ),
          ],
        ),
        5.verticalSpace,
        Expanded(
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.darkElevation,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: context.watch<FavoritesProvider>().isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var name in favorites.take(5).toList()) ...[
                                ListTextFav(text: name),
                                10.verticalSpace,
                              ]
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      MainButton(
                        text: 'More...',
                        hollow: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        onPressed: () {
                          Navigator.pushNamed(context, '/Favorites');
                        },
                      )
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
