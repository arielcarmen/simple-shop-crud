import 'package:flutter/material.dart';
import 'package:m_ola/widgets/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("assets/logos/logo_blanc.png"),
                    height: 400,
                  ),
                  GoogleSignInButton()
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
