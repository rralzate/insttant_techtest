import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/routes/global_keys.dart';
import 'core/routes/navigators.dart';
import 'core/routes/page_generator.dart';

import 'core/theme/app_them.dart';
import 'core/utils/user_activity_detector.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return UserActivityDetector(
          child: GetMaterialApp(
            navigatorKey: globalNavigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Insttant Plus',
            locale: const Locale('es', 'ES'),
            theme: appTheme,
            scaffoldMessengerKey: messageKey,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: PageClassGenerator.getNamedScreen,
          ),
        );
      },
    );
  }
}
