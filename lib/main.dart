import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_ola/views/homescreen.dart';
import 'package:m_ola/utils/tools.dart';
import 'package:page_transition/page_transition.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Themes.pinkTint,
      fontFamily: 'Poppins'
    ),
    home: AnimatedSplashScreen(
      splash: "assets/logos/logo_blanc.png",
      splashIconSize: 250,
      nextScreen: const HomeScreen(),
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 2),
      pageTransitionType: PageTransitionType.fade,
    ),
  ));
}

