import 'package:btt/model/entities/map_location.dart';
import 'package:btt/providers/favorites_provider.dart';
import 'package:btt/providers/user_provider.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/services/user_services.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../tools/response.dart';
import '../../global/constants/text_styles.dart';

class AddToFavoritePage extends StatefulWidget {
  const AddToFavoritePage({super.key});

  @override
  State<AddToFavoritePage> createState() => _AddToFavoritePageState();
}

class _AddToFavoritePageState extends State<AddToFavoritePage> {
  late final Future<Response<List<MapLocation>>> allLocations;
  late final TextEditingController controller;
  List<MapLocation> resultLocations = [];
  List<MapLocation> filteredLocations = [];
  bool locationsLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    allLocations = LocationServices.getLocations();
    allLocations.then((response) {
      setState(() {
        resultLocations = response.data!;
        filteredLocations = resultLocations;
        locationsLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'All Locations',
          style: TextStyles.largeTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            AppTextField(
              controller: controller,
              hintText: 'Search',
              suffix: const Icon(Icons.location_on_outlined),
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (text) {
                setState(() {
                  filteredLocations = filterResults(resultLocations, text);
                });
              },
            ),
            const SizedBox(height: 30),
            locationsLoaded
                ? Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return LocationTile(location: filteredLocations[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: filteredLocations.length,
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LocationTile extends StatefulWidget {
  final MapLocation location;
  const LocationTile({
    super.key,
    required this.location,
  });

  @override
  State<LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends State<LocationTile> {
  late bool inFavorite;

  @override
  void initState() {
    super.initState();
    inFavorite = context.read<FavoritesProvider>().checkIsInFavorite(widget.location.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkElevation,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 20, right: 5),
        title: Text(
          widget.location.name,
          style: TextStyles.body,
        ),
        trailing: inFavorite
            ? IconButton(
                onPressed: () {},
                color: AppColors.red,
                icon: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.elevationOne,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.favorite_rounded,
                  ),
                ),
              )
            : IconButton(
                onPressed: () {
                  context.read<FavoritesProvider>().addLocation(widget.location);
                  String userId = context.read<UserProvider>().user.id;
                  UserServices.addFavorite(userId, widget.location.id);
                  setState(() {
                    inFavorite = context.read<FavoritesProvider>().checkIsInFavorite(widget.location.id);
                  });
                },
                color: AppColors.accent1,
                icon: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.elevationOne,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ),
      ),
    );
  }
}

List<MapLocation> filterResults(List<MapLocation> locations, String? searchText) {
  if (searchText == null || searchText.isEmpty) return locations;
  final filteredLocations = locations.where((location) {
    return location.name.toLowerCase().startsWith(searchText.toLowerCase());
  }).toList();

  return filteredLocations;
}
