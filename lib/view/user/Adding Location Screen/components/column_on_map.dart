import 'package:btt/providers/choose_on_map_provider.dart';
import 'package:btt/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../../../services/location_permission_services.dart';
import '../../../global/constants/colors.dart';
import '../../home page/components/static_pickup_destination_container.dart';

class ColumnOnMap extends StatefulWidget {
  final TextEditingController pickUpCtrl;
  final TextEditingController destinationCtrl;
  final locationController;

  const ColumnOnMap({super.key, required this.pickUpCtrl, required this.destinationCtrl, required this.locationController,});

  @override
  State<ColumnOnMap> createState() => _ColumnOnMapState();
}

class _ColumnOnMapState extends State<ColumnOnMap> {

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChooseOnMapProvider,MapProvider>(
        builder: (context, ChooseOnMapProvider,MapProvider,_){
      return Column(
        mainAxisSize: ChooseOnMapProvider.isSelected
            ? MainAxisSize.max
            : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: ChooseOnMapProvider.isSelected ? null : 80.r,
            width: ChooseOnMapProvider.isSelected ? null : 80.r,
            child: !ChooseOnMapProvider.isSelected
                ? FloatingActionButton(
                   backgroundColor: AppColors.darkElevation.withOpacity(0.9),
                   shape: const CircleBorder(),
                   onPressed: () async {
                     bool granted = await LocationPermissionServices().accessPermission(widget.locationController);
                     if (!granted) {
                       return;
                     }
                     LocationData userLocation =
                     await widget.locationController.getLocation();
                      MapProvider.changeMapController(userLocation);
                   },
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 40.r,
                      ),
            )
                : null,
          ),
          22.verticalSpace,
          GestureDetector(
            onTap: (){
              ChooseOnMapProvider.setIsSelectedToTrue();
            },
            child: AnimatedAlign(
              alignment: ChooseOnMapProvider.isSelected
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: ChooseOnMapProvider.isSelected
                      ? AppColors.elevationOne
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: StaticPickUpDestContainer(
                    opacity: 0.95,
                    pickUpCtrl: widget.pickUpCtrl,
                    destinationCtrl: widget.destinationCtrl,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
