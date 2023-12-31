import 'package:btt/model/entities/map_location.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/request_handler.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/input/app_drop_down.dart';
import 'package:btt/view/widgets/input/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                BTTDropdownButton(
                  items: const {
                    'key1': 'value1',
                    'key2': 'value2',
                    'key3': 'value3',
                    'key4': 'value4',
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  icon: Icons.location_on,
                  hint: 'start',
                ),
                16.verticalSpace,
                BTTDropdownButton(
                  items: const {
                    'key1': 'value1',
                    'key2': 'value2',
                    'key3': 'value3',
                    'key4': 'value4',
                  },
                  onChanged: (value) {
                    print(value);
                  },
                  icon: Icons.location_on,
                  hint: 'start',
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
