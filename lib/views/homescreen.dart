import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
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
