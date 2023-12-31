import 'package:btt/model/entities/map_location.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/request_handler.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/constants/colors.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _isLoading = false;
  List<String> values = [
    'Ahmed',
    'Gamil',
    'Fathy',
    'Ibrahim',
    'Khalil',
    'Rabie',
  ];
  late List<MapLocation> locations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Route', style: TextStyles.large),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: LocationSelector(
                          onLocationSelected: (LatLng location) {
                            _latitudeController.text = location.latitude.toString();
                            _longitudeController.text = location.longitude.toString();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                      border: const Border.fromBorderSide(
                        BorderSide(color: AppColors.elevationOne, width: 2),
                      ),
                      borderRadius: BorderRadius.circular(25.r)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColors.elevationOne,
                      shadowColor: AppColors.darkElevation,
                    ),
                    child: ReorderableListView(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      shrinkWrap: true,
                      children: values
                          .map((value) => ClipRRect(
                                key: ValueKey(value),
                                borderRadius: BorderRadius.circular(25.r),
                                child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.r)),
                                    key: ValueKey(value),
                                    title: Text(
                                      value,
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
                ),
                16.verticalSpace,
                MainButton(
                  text: 'Create',
                  onPressed: _isLoading ? null : _createLocation,
                  loading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void rearrangeList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    values.insert(newIndex, values.removeAt(oldIndex));
    setState(() {});
  }

  Future<void> _createLocation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await RequestHandler.handleRequest(
        context: context,
        service: () => LocationServices.createLocation(
          MapLocation(
            name: _nameController.text,
            latitude: double.parse(_latitudeController.text),
            longitude: double.parse(_longitudeController.text),
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
    }

    setState(() {
      _isLoading = false;
    });

    return;
  }
}
