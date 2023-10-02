import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_ola/views/login.dart';
import 'package:m_ola/utils/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/tools.dart';


class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user}) : _user = user,super(key: key);

  final User _user;
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {

  late User _user;
  bool _isSigningOut = false;

  // Route _routeToHomeScreen() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = const Offset(-1.0, 0.0);
  //       var end = Offset.zero;
  //       var curve = Curves.ease;
  //
  //       var tween =
  //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //
  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: CustomColors.firebaseNavy,
      //   title: AppBarTitle(),
      // ),
      appBar: AppBar(
        title: const Text("Mon compte"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_user.photoURL != null) Container(
              height: MediaQuery.of(context).size.width*0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/logos/logo_blanc_full.png',
                  image: _user.photoURL!,
                  // fit: BoxFit.fitHeight,
                ),
              ),
            ) else Container(
              height: MediaQuery.of(context).size.width*0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image(
                    // fit: BoxFit.fitHeight,
                    image: AssetImage(
                        "assets/logos/logo_blanc_full.png"
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Hello',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 8.0),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                _user.displayName!,
                style: TextStyle(
                  color: Colors.yellow[350],
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                _user.email!,
                style: TextStyle(
                  color: Themes.pinkTint[200],
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              '.',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  letterSpacing: 0.2),
            ),
            const SizedBox(height: 16.0),
            if (_isSigningOut) const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ) else ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                var isLoggedIn = prefs.setBool('logged', false);
                var admin = prefs.setBool('admin', false);
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  'Deconnexion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
