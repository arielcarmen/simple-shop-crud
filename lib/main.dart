import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_ola/views/details.dart';
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
    home:LoginScreen(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar'),
        actions: [
          IconButton(
            onPressed: (){
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User user = auth.currentUser!;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => UserInfoScreen(user: user)
                  )
              );
            },
            icon: const Icon(
              Icons.person
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}

