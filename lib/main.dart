import 'package:btt/cache/cache_manager.dart';
import 'package:btt/providers/favorites_provider.dart';
import 'package:btt/providers/pages_provider.dart';
import 'package:btt/providers/user_provider.dart';
import 'package:btt/services/location_services.dart';
import 'package:btt/tools/firebase_options.dart';
import 'package:btt/view/admin/admin_home_page.dart';
import 'package:btt/view/admin/create%20bus%20screen/create_bus_screen.dart';
import 'package:btt/view/admin/create%20location%20screen/create_location_screen.dart';
import 'package:btt/view/admin/create%20route%20screen/create_route_screen.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/screens/landing_screen.dart';
import 'package:btt/view/screens/sign_in.dart';
import 'package:btt/view/screens/sign_up.dart';
import 'package:btt/view/user/Adding%20Location%20Screen/current_location_screen.dart';
import 'package:btt/view/user/favorites%20page/favorites.dart';
import 'package:btt/view/user/home%20page/user_home_page.dart';
import 'package:btt/view/user/skeleton/skeleton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'model/entities/map_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('db');
  runApp(const MyApp());
}

Future<MapLocation?> getNearestRegisteredLocation(LatLng targetLocation) async {
  final List<MapLocation> locations = ((await LocationServices.getLocations())).data ?? [];
  double minDistance = double.infinity;
  MapLocation? nearestLocation;

  for (final MapLocation location in locations) {
    final double distance = location.distanceToLocationFromLatLng(targetLocation);
    if (distance < minDistance) {
      minDistance = distance;
      nearestLocation = location;
    }
  }

  return nearestLocation;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CacheManager()..init()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => PagesProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bus Transit Transportation',
          theme: ThemeData(
            fontFamily: 'Nunito',
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent1),
            scaffoldBackgroundColor: AppColors.background,
            useMaterial3: true,
            dialogTheme: const DialogTheme(
              backgroundColor: AppColors.elevationOne,
              surfaceTintColor: Colors.transparent,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.background,
              elevation: 0,
            ),
          ),
          routes: {
            '/SignIn': (context) => const SignIn(),
            '/Signup': (context) => const SignUpPage(),
            '/AdminHome': (context) => const AdminHomePage(),
            '/CreateLocation': (context) => const CreateLocationScreen(),
            '/CreateRoute': (context) => const CreateRouteScreen(),
            '/CreateBus': (context) => const CreateBusScreen(),
            '/UserHome': (context) => const UserHomePage(),
            '/MapSelector': (context) => const CurrentLocationScreen(),
            '/LandingScreen': (context) => const LandingScreen(),
            '/Skeleton': (context) => const Skeleton(),
            '/Favorites': (context) => const FavoritesPage(),
          },
          initialRoute: '/LandingScreen',
        ),
      ),
    );
  }
}
