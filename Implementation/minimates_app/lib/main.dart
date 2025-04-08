// import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'package:untitled1/auth/auth_page.dart';
import 'package:untitled1/auth/main_page.dart';
import 'screens/bottom_nav_bar.dart';

import 'package:untitled1/utils/theme/theme.dart';
import 'package:get/get.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'), // Required for web
    androidProvider: AndroidProvider.playIntegrity, // Use Play Integrity for Android
    appleProvider: AppleProvider.appAttest, // Use App Attest for iOS
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Minimates App',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.top,
        depth: 200,
      ),
      // darkTheme: NeumorphicThemeData(
      //   baseColor: Color(0xFF3E3E3E),
      //   lightSource: LightSource.top,
      //   depth: 6,
      // ),
      // home: OnBoardingScreen(),
      // navigatorKey: Get.key,
      // home:BottomNavBar(),
        home:Main_Page()
    );
  }
}
