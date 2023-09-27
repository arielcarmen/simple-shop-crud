import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_ola/views/list.dart';
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

class _HomeScreenState extends State<HomeScreen>{
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');
  var productCount = 0;
  String productValue = "";

  @override
  void initState() {
    super.initState();
    _productsStream.snapshots().listen((event) {
      setState(() {
        _productsStream.count().get().then(
              (res) => productCount = res.count,
          onError: (e) => print("Error completing: $e"),
        );
      });
    });
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if(state == AppLifecycleState.resumed){
  //
  //   }else if(state == AppLifecycleState.inactive){
  //     // app is inactive
  //   }else if(state == AppLifecycleState.paused){
  //     // user is about quit our app temporally
  //   }else if(state == AppLifecycleState.detached){
  //     // app suspended (not used in iOS)
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    productValue =  productCount.toString();
    return Scaffold(
      backgroundColor: const Color(0xfffffff4),
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            onPressed: () async {
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
          GestureDetector(
            onLongPress: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Products())
              );
            },
            onTap: () {

            },
            child: Card(
              // elevation: 10,
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
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              '$productCount',
                              style: const TextStyle(fontSize: 32, color: Colors.pink),
                            ),
                            const SizedBox(width: 5,),
                            const Text(
                              'produits enregistrés',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          '*Appui long pour voir la liste complète',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 3,
              children: const [
                CustomMenuTile(title: "Savon", pic: AssetImage("assets/icons/cleansing.png")),
                CustomMenuTile(title: "Lotion", pic: AssetImage("assets/icons/ampoule.png")),
              ],
            ),
          )
        ],
      ),
    );
  }

}

