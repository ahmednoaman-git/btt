import 'package:btt/model/entities/map_location.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/request_handler.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateLocationScreen extends StatefulWidget {
  const CreateLocationScreen({super.key});

  @override
  State<CreateLocationScreen> createState() => _CreateLocationScreenState();
}

class _CreateLocationScreenState extends State<CreateLocationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Location', style: TextStyles.large),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.location_on_rounded),
                  hintText: 'Name',
                ),
                16.verticalSpace,
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
                AppTextField(
                  controller: _latitudeController,
                  prefixIcon: const Icon(Icons.numbers_rounded),
                  hintText: 'Latitude',
                ),
                16.verticalSpace,
                AppTextField(
                  controller: _longitudeController,
                  prefixIcon: const Icon(Icons.numbers_rounded),
                  hintText: 'Longitude',
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
