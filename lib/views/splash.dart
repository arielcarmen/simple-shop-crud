import 'package:flutter/material.dart';
import 'package:m_ola/views/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    toWelcomeScreen();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: 'splash-welcome',
            child: Image(
              image: AssetImage("assets/logos/logo_blanc.png"),
              height: 400,
            ),
          ),
        ),
      ),
    );
  }

  void toWelcomeScreen(){
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
}
