import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_ola/views/login.dart';
import 'package:m_ola/widgets/custom_menu_tile.dart';
import 'details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');
  int productCount = 0;
  String productValue = "";

  @override
  Widget build(BuildContext context) {
    productValue =  productCount.toString();
    return Scaffold(
      backgroundColor: const Color(0xfffffff5),
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            onPressed: () async {
              _getProductsCount();

              final FirebaseAuth auth = FirebaseAuth.instance;
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              bool isLoggedIn = prefs.getBool('logged')!;
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => isLoggedIn ? UserInfoScreen(user: auth.currentUser!) : const LoginScreen()
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      spreadRadius: 2.0
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$productValue',
                        style: TextStyle(fontSize: 22, color: Colors.pink),
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
          Expanded(
            child: GridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount: 3,
              children: const [

                CustomMenuTile(title: "Savon", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Lotion", pic: AssetImage("assets/icons/ampoule.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Savons", pic: AssetImage("assets/icons/cleansing.png")),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _getProductsCount() async{
    productCount = await _productsStream.snapshots().length;
    print(_productsStream.snapshots());
    setState(() {
      productValue = productCount.toString();
    });
  }
}

