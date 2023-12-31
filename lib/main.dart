import 'package:btt/tools/firebase_options.dart';
import 'package:btt/view/admin/create_route_screen.dart';
import 'package:btt/view/global/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent1),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          dialogTheme: const DialogTheme(
            surfaceTintColor: Colors.transparent,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
          ),
        ),
        home: const CreateRouteScreen(),
      ),
    );
  }
}
