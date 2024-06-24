import 'package:btt/providers/search_screen_provider.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/user/view_lookup_path.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<SearchScreenProvider>(
      builder: (BuildContext context, SearchScreenProvider searchScreenProvider, Widget? child) {
        final bool selectingStartLocation = searchScreenProvider.startLocation == null;
        return Stack(
          children: [
            LocationSelector(
              onLocationSelected: (LatLng location) {
                searchScreenProvider.currentlySelectedLocation = location;
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 0),
                // Selecting start/end location label
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _locationSelectedCheckmark(searchScreenProvider.startLocation != null),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10.r,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        selectingStartLocation ? 'Select Start Location' : 'Select Destination Location',
                        style: TextStyles.body,
                      ),
                    ),
                    _locationSelectedCheckmark(searchScreenProvider.destinationLocation != null),
                  ],
                ),
              ),
            ),

            // Confirm Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: MainButton(
                        onPressed: () {
                          if (searchScreenProvider.currentlySelectedLocation == null) {
                            return;
                          }
                          if (selectingStartLocation) {
                            searchScreenProvider.setStartLocation(searchScreenProvider.currentlySelectedLocation!);
                          } else {
                            searchScreenProvider.setDestinationLocation(searchScreenProvider.currentlySelectedLocation!);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ViewLookupPathScreen(
                                  startLocation: searchScreenProvider.startLocation!,
                                  endLocation: searchScreenProvider.destinationLocation!,
                                ),
                              ),
                            );
                          }
                        },
                        text: 'Confirm',
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: MainButton(
                        hollow: true,
                        onPressed: () {
                          searchScreenProvider.clear();
                        },
                        text: 'Clear',
                        color: AppColors.accent1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ));
  }

  Widget _locationSelectedCheckmark(bool isSelected) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSelected
          ? const Icon(
              Icons.check_circle,
              color: CupertinoColors.systemGreen,
              size: 30,
              key: ValueKey('selected'),
            )
          : const Icon(
              Icons.circle_outlined,
              color: Colors.white,
              size: 30,
              key: ValueKey('not_selected'),
            ),
    );
  }
}
