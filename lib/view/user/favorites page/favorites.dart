import 'package:btt/model/entities/map_location.dart';
import 'package:btt/providers/favorites_provider.dart';
import 'package:btt/providers/user_provider.dart';
import 'package:btt/services/user_services.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/misc/mini_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<FavoritesProvider>().isLoading;
    final List<MapLocation> favorites = context.watch<FavoritesProvider>().favoriteLocations;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Favorites',
          style: TextStyles.largeTitle,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    for (MapLocation mapLocation in favorites) ...[
                      FavoriteTile(
                        location: mapLocation,
                      ),
                      20.verticalSpace,
                    ],
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent1.withOpacity(0.8),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed('/AddToFavorites');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FavoriteTile extends StatelessWidget {
  final MapLocation location;
  const FavoriteTile({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: AppColors.accent1.withOpacity(0.2)),
      child: ExpansionTile(
        title: Text(
          location.name,
          style: TextStyles.body,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        childrenPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        backgroundColor: AppColors.darkElevation,
        collapsedBackgroundColor: AppColors.darkElevation,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: MiniMap(latitude: location.latitude, longitude: location.longitude),
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent1.withOpacity(0.5),
                ),
                child: Text(
                  'Select Destination',
                  style: TextStyles.button,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  context.read<FavoritesProvider>().deleteLocation(location);
                  final String userId = context.read<UserProvider>().user.id;
                  UserServices.removeFavoriteLocation(userId, location.id);
                },
                child: Text(
                  'Delete',
                  style: TextStyles.button.apply(color: AppColors.red),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
