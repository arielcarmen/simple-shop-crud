import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_ola/views/details.dart';
import 'package:m_ola/views/homescreen.dart';
import 'package:m_ola/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink,
      primaryColor: Colors.pinkAccent
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const LoginScreen(),
      '/products': (context) => const HomeScreen(),
    },
  ));
}

