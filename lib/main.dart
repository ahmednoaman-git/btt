import 'package:btt/services/route_services.dart';
import 'package:btt/tools/firebase_options.dart';
import 'package:btt/view/admin/admin_home_page.dart';
import 'package:btt/view/admin/create%20bus%20screen/create_bus_screen.dart';
import 'package:btt/view/admin/create%20location%20screen/create_location_screen.dart';
import 'package:btt/view/admin/create%20route%20screen/create_route_screen.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:btt/view/user/home%20page/user_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  RouteServices.getRoutes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
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
          '/AdminHome': (context) => const AdminHomePage(),
          '/CreateLocation': (context) => const CreateLocationScreen(),
          '/CreateRoute': (context) => const CreateRouteScreen(),
          '/CreateBus': (context) => const CreateBusScreen(),
          '/UserHome': (context) => const UserHomePage(),
        },
        initialRoute: '/UserHome',
      ),
    );
  }
}
