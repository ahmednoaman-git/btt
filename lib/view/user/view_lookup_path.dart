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
  final LatLng startLocation;
  final LatLng endLocation;
  const ViewLookupPathScreen({super.key, required this.startLocation, required this.endLocation});

  @override
  State<ViewLookupPathScreen> createState() => _ViewLookupPathScreenState();
}

class _ViewLookupPathScreenState extends State<ViewLookupPathScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late String _darkMapStyle;
  CameraPosition? _currentCameraPosition;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  bool _initialized = false;
  final List<ViewablePath> viewablePath = [];

  late final String _startLocationId;
  late final String _endLocationId;

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
  }

  Color _getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  Future<void> _loadPolylinePoints(List<ViewablePath> viewablePath, MapLocation startLocation, LatLng startPoint, MapLocation endLocation, LatLng endPoint) async {
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
      _markers.add(
        Marker(
          markerId: MarkerId('startMarker$i'),
          position: stops.first.toLatLng(),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ),
      );
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
        color: AppColors.accent1,
        points: polylineCoordinates,
        width: 5,
      );
      _polylines.add(polyline);

      await _getWalkPolyline(startPoint, startLocation.toLatLng());

      await _getWalkPolyline(endLocation.toLatLng(), endPoint);
    }
  }

  String _getNearestLocationToLatLng(LatLng targetLocation, List<MapLocation> locations) {
    double minDistance = double.infinity;
    String nearestLocationId = locations.first.id;
    for (final MapLocation location in locations) {
      final double distance = location.distanceToLocationFromLatLng(targetLocation);
      if (distance < minDistance) {
        minDistance = distance;
        nearestLocationId = location.id;
      }
    }
    return nearestLocationId;
  }

  Future<void> _getWalkPolyline(LatLng startLocation, LatLng endLocation) async {
    final PolylineId id = PolylineId('walkPolyline+ $startLocation +$endLocation');
    final result = await PolylinePoints().getRouteBetweenCoordinates(
      Constants.googleMapsApiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.walking,
    );
    final List<LatLng> polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    final Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.white,
      points: polylineCoordinates,
      width: 5,
    );

    _polylines.add(polyline);
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/themes/dark_map.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.elevationOne,
      body: Consumer<CacheManager>(
        builder: (context, cacheManager, _) {
          if (cacheManager.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!_initialized) {
            final locations = cacheManager.locations.values.toList();
            _startLocationId = _getNearestLocationToLatLng(widget.startLocation, locations);
            _endLocationId = _getNearestLocationToLatLng(widget.endLocation, locations);

            final path = cacheManager.graph.dijkstra(_startLocationId, _endLocationId);
            viewablePath.addAll([
              ...PathSearchingUtils.getViewablePathFromEdges(
                path,
                locations,
                cacheManager.buses.values.toList(),
              ),
            ]);
            _loadPolylinePoints(
              viewablePath,
              cacheManager.locations[_startLocationId]!,
              widget.startLocation,
              cacheManager.locations[_endLocationId]!,
              widget.endLocation,
            ).then((value) {
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
                    markers: _markers,
                  ),
                ),
              ),
              if (viewablePath.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: PathDetailsSection(
                      viewablePath: viewablePath,
                      startWalkPath: WalkPath(
                        distance: cacheManager.locations[_startLocationId]!.distanceToLocationFromLatLng(widget.startLocation),
                        duration: const Duration(minutes: 5),
                        startLabel: 'Start',
                        endLabel: viewablePath.first.stops.first.name,
                      ),
                      startLocation: cacheManager.locations[_startLocationId]!,
                      endWalkPath: WalkPath(
                        distance: cacheManager.locations[_endLocationId]!.distanceToLocationFromLatLng(widget.endLocation),
                        duration: const Duration(minutes: 5),
                        startLabel: viewablePath.last.stops.last.name,
                        endLabel: 'Destination',
                      ),
                    ),
                  ),
                ),
              if (viewablePath.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No path found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
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

class WalkPath {
  final double distance;
  final Duration duration;
  final String startLabel;
  final String endLabel;

  WalkPath({
    required this.distance,
    required this.duration,
    required this.startLabel,
    required this.endLabel,
  });
}
