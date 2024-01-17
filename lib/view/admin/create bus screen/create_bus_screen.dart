import 'package:btt/model/entities/bus.dart';
import 'package:btt/model/entities/map_location.dart';
import 'package:btt/model/entities/route.dart';
import 'package:btt/services/bus_services.dart';
import 'package:btt/services/route_services.dart';
import 'package:btt/view/admin/create%20bus%20screen/component/route_tile.dart';
import 'package:btt/view/global/constants/text_styles.dart';
import 'package:btt/view/widgets/action/main_button.dart';
import 'package:btt/view/widgets/api/request_widget.dart';
import 'package:btt/view/widgets/input/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../tools/request_handler.dart';
import '../../../tools/response.dart';
import '../../widgets/input/app_drop_down.dart';

class CreateBusScreen extends StatefulWidget {
  const CreateBusScreen({super.key});

  @override
  State<CreateBusScreen> createState() => _CreateBusScreenState();
}

class _CreateBusScreenState extends State<CreateBusScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _fareController = TextEditingController();

  bool _isLoading = true;

  late final Future<Response<List<MapRoute>>> _locationsRequest;
  List<MapRoute> routes = [];

  String? chosenRouteId;
  BusStatus? chosenStatus;

  Future<Response<MapRoute>>? selectedRoute;

  @override
  void initState() {
    _locationsRequest = RouteServices.getRoutes();
    _locationsRequest.then((value) {
      if ((value.success)) {
        routes = value.data!;
        _isLoading = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bus', style: TextStyles.large),
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
                  prefixIcon: const Icon(Icons.drive_file_rename_outline),
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'required';
                    } else {
                      return null;
                    }
                  },
                ),
                16.verticalSpace,
                AppTextField(
                  controller: _departureTimeController,
                  prefixIcon: const Icon(Icons.date_range),
                  hintText: 'Departure Time (06-04-2001 10:00 AM)',
                  validator: (value) {
                    try {
                      parseToDateTime(value!);
                    } catch (e) {
                      return 'incorrect format';
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                AppTextField(
                    controller: _fareController,
                    prefixIcon: const Icon(Icons.money_off),
                    hintText: 'Fare',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'required';
                      } else {
                        return null;
                      }
                    }),
                16.verticalSpace,
                BTTDropdownButton(
                  icon: Icons.library_add_check_outlined,
                  items: const {
                    BusStatus.inStation: 'In Station',
                    BusStatus.operating: 'Operating',
                    BusStatus.outOfService: 'Out of Service',
                  },
                  onChanged: (value) {
                    chosenStatus = value as BusStatus;
                  },
                  hint: 'Status',
                ),
                16.verticalSpace,
                BTTDropdownButton(
                  icon: Icons.route,
                  items: {for (MapRoute route in routes) route.id: route.name},
                  onChanged: (value) {
                    chosenRouteId = value as String;
                    selectedRoute = RouteServices.getRouteFromId(chosenRouteId!);
                    setState(() {});
                  },
                  loadingData: _isLoading,
                  hint: 'Route',
                ),
                16.verticalSpace,
                (chosenRouteId == null)
                    ? const SizedBox.shrink()
                    : RequestWidget(
                        request: selectedRoute!,
                        successWidgetBuilder: (data) {
                          return RouteTile(
                            route: data,
                          );
                        }),
                16.verticalSpace,
                MainButton(
                  text: 'Create Bus',
                  onPressed: _isLoading ? null : _createBus,
                  loading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createBus() async {
    if (_formKey.currentState!.validate() && chosenRouteId != null && chosenStatus != null) {
      setState(() {
        _isLoading = true;
      });

      await RequestHandler.handleRequest(
        context: context,
        service: () => BusServices.createBus(
          Bus(
              id: '',
              identifier: _nameController.text,
              routeId: chosenRouteId!,
              departureTime: parseToDateTime(_departureTimeController.text),
              status: chosenStatus!,
              currentLocation: MapLocation.emptyLocation(),
              fare: double.parse(_fareController.text)),
        ),
        enableLoadingDialog: false,
        successTitle: 'Success',
        successMessage: 'Your Bus has been created successfully.',
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

  DateTime parseToDateTime(String dateStr) {
    DateFormat format = DateFormat('dd-MM-yyyy HH:mm a');
    DateTime dateTime = format.parse(dateStr);
    return dateTime;
  }
}
