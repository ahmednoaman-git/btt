import 'package:btt/model/entities/map_location.dart';
import 'package:btt/model/entities/route.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/services/route_services.dart';
import 'package:btt/tools/request_handler.dart';
import 'package:btt/tools/response.dart';
import 'package:btt/view/admin/create%20route%20screen/components/location_selection_tile.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/api/request_widget.dart';
import 'package:btt/view/widgets/dialog/error_dialog.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final TextEditingController _locationsSearchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final Future<Response<List<MapLocation>>> _locationsRequest = LocationServices.getLocations();

  bool _isLoading = false;
  final List<MapLocation> _selectedLocations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Route', style: TextStyles.large),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                hintText: 'Name',
                prefixIcon: const Icon(Icons.drive_file_rename_outline_outlined),
              ),
              16.verticalSpace,
              MainButton(
                text: 'Select Locations',
                icon: Icon(Icons.list_rounded, color: AppColors.text, size: 20.r),
                hollow: true,
                onPressed: _showLocationSelectionDialog,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: AppColors.elevationOne,
                ),
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  shrinkWrap: true,
                  children: _selectedLocations
                      .map((value) => ClipRRect(
                            key: ValueKey(value),
                            borderRadius: BorderRadius.circular(25.r),
                            child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r)),
                                key: ValueKey(value),
                                title: Text(
                                  value.name,
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                  ),
                                )),
                          ))
                      .toList(),
                  onReorder: (oldIndex, newIndex) {
                    rearrangeList(oldIndex, newIndex);
                  },
                ),
              ),
              16.verticalSpace,
              MainButton(
                text: 'Create Route',
                icon: Icon(Icons.add_circle_rounded, color: AppColors.text, size: 20.r),
                onPressed: _createLocation,
                loading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void rearrangeList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    _selectedLocations.insert(newIndex, _selectedLocations.removeAt(oldIndex));
    setState(() {});
  }

  void _showLocationSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            width: 0.9.sw,
            height: 300.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: _locationsSearchController,
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.text, size: 20.r),
                  hintText: 'Search',
                  onChanged: (value) {
                    setState(() {});
                  },
                  fillColor: AppColors.darkElevation,
                ),
                16.verticalSpace,
                Expanded(
                  child: RequestWidget<List<MapLocation>>(
                    request: _locationsRequest,
                    successWidgetBuilder: (List<MapLocation> locations) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final location = locations[index];
                          return AspectRatio(
                            aspectRatio: 1.1,
                            child: LocationSelectionTile(
                              isSelected: _selectedLocations.contains(location),
                              location: location,
                              onTap: () {
                                if (_selectedLocations.contains(location)) {
                                  _selectedLocations.remove(location);
                                } else {
                                  _selectedLocations.add(location);
                                }
                                setState(() {});
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => 16.horizontalSpace,
                      );
                    },
                  ),
                ),
                16.verticalSpace,
                MainButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {});
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _createLocation() async {
    if (_selectedLocations.length < 2) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          title: 'Error',
          message: 'Please select at least 2 locations.',
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    await RequestHandler.handleRequest(
      context: context,
      service: () => RouteServices.createRoute(
        MapRoute(
          name: _nameController.text,
          stops: _selectedLocations,
          start: _selectedLocations.first,
          end: _selectedLocations.last,
        ),
      ),
      enableLoadingDialog: false,
      successTitle: 'Success',
      successMessage: 'Your location has been created successfully.',
      redirect: true,
      redirection: () {
        Navigator.pop(context);
      },
      redirectDelay: 3,
    );

    setState(() {
      _isLoading = false;
    });

    return;
  }
}
