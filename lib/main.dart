import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_ola/views/homescreen.dart';
import 'package:m_ola/utils/tools.dart';
import 'package:m_ola/views/splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: BlueTheme.blueTint,
      primaryColor: Colors.pink[200],
      fontFamily: 'Poppins'
    ),
    home: const SplashScreen(),
  ));
}

