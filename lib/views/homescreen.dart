import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            onPressed: (){
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User user = auth.currentUser!;
              Navigator.of(context).push(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Card(
            elevation: 10,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffc0c0c0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      spreadRadius: 2.0
                    )
                  ]
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'w XOF',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Retraits Mobigo (7 derniers jours)',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // GridView.count(
          //   crossAxisCount: 2,
          // )
        ],
      ),
    );
  }
}
