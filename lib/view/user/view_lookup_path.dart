import 'dart:async';
import 'dart:math';

import 'package:btt/cache/cache_manager.dart';
import 'package:btt/model/entities/map_location.dart';
import 'package:btt/utils/path_searching_utils.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/global/constants/constants.dart';
import 'package:btt/view/user/path_details_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ViewLookupPathScreen extends StatefulWidget {
  const ViewLookupPathScreen({super.key});

  @override
  State<ViewLookupPathScreen> createState() => _ViewLookupPathScreenState();
}

class _ViewLookupPathScreenState extends State<ViewLookupPathScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late String _darkMapStyle;
  CameraPosition? _currentCameraPosition;
  final Set<Polyline> _polylines = {};
  bool _initialized = false;
  final List<ViewablePath> viewablePath = [];

  static const String _startLocationId = 'Hy7UwIFm6an7cHzBTSV0';
  static const String _endLocationId = '2FITQkiMDT7ZIKzc8j1M';

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
  }

  Color _getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  Future<void> _loadPolylinePoints(List<ViewablePath> viewablePath, MapLocation startLocation) async {
    PolylinePoints polyPoints = PolylinePoints();
    for (int i = 0; i < viewablePath.length; i++) {
      final List<LatLng> polylineCoordinates = [];
      final ViewablePath path = viewablePath[i];
      final List<MapLocation> stops = path.stops;
      if (i != 0) {
        stops.insert(0, viewablePath[i - 1].stops.last);
      } else {
        stops.insert(0, startLocation);
      }
      for (int j = 0; j < stops.length - 1; j++) {
        final result = await polyPoints.getRouteBetweenCoordinates(
          Constants.googleMapsApiKey,
          PointLatLng(stops[j].latitude, stops[j].longitude),
          PointLatLng(stops[j + 1].latitude, stops[j + 1].longitude),
        );
        if (result.points.isNotEmpty) {
          for (PointLatLng point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }
      }

      final PolylineId id = PolylineId('polyline${i + 1}');
      final Polyline polyline = Polyline(
        polylineId: id,
        color: _getRandomColor(),
        points: polylineCoordinates,
        width: 5,
      );
      _polylines.add(polyline);
    }
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/themes/dark_map.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.elevationOne,
      body: Consumer<CacheManager>(builder: (context, cacheManager, _) {
        if (cacheManager.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!_initialized) {
          final path = cacheManager.graph.dijkstra(_startLocationId, _endLocationId);
          viewablePath.addAll([
            ...PathSearchingUtils.getViewablePathFromEdges(
              path,
              cacheManager.locations.values.toList(),
              cacheManager.buses.values.toList(),
            ),
          ]);

          _loadPolylinePoints(viewablePath, cacheManager.locations[_startLocationId]!).then((value) {
            setState(() {});
          });
          _initialized = true;
        }
        return Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: AppColors.background.withOpacity(0.5), offset: const Offset(0, 2), blurRadius: 4)],
                ),
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    controller.setMapStyle(_darkMapStyle);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {
                        controller.animateCamera(
                          CameraUpdate.newLatLngBounds(
                            _getBounds([
                              ...viewablePath.expand((element) => element.stops.map((e) => LatLng(e.latitude, e.longitude))),
                            ]),
                            50,
                          ),
                        );
                      });
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: PathSearchingUtils.getBestCenterForPath(cacheManager.locations[_startLocationId]!, cacheManager.locations[_endLocationId]!),
                  ),
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  onCameraMove: (CameraPosition position) {
                    _currentCameraPosition = position;
                  },
                  polylines: _polylines,
                ),
              ),
            ),
            Expanded(
              child: PathDetailsSection(
                viewablePath: viewablePath,
                startLocation: cacheManager.locations[_startLocationId]!,
              ),
            ),
          ],
        );
      }),
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (point.longitude < minLng) {
        minLng = point.longitude;
      }
      if (point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
