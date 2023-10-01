import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_ola/views/list.dart';
import 'package:m_ola/views/login.dart';
import 'package:m_ola/widgets/custom_menu_tile.dart';
import 'details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_ola/utils/tools.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');
  var productCount = 0;

  @override
  void initState() {
    _productsStream.snapshots().listen((event) {
      _updateProductsNumber();
    });
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bienvenue !'),
        actions: [
          IconButton(
            onPressed: () async {
              final FirebaseAuth auth = FirebaseAuth.instance;
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.containsKey("logged")){
                bool isLoggedIn = prefs.getBool('logged')!;
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => (isLoggedIn) ? UserInfoScreen(user: auth.currentUser!) : const LoginScreen()
                    )
                );
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()
                )
                );
              }
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
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.3),
                child: Card(
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Total enregistré',
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  '$productCount article(s)',
                                  style: const TextStyle(fontSize: 32, color: Colors.pink),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(100),
                      color: Themes.pinkTint[20]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: GestureDetector(
                        onTap: (){
                          print(productCount);
                        },
                        child: Image(
                          image: const AssetImage('assets/logos/logo_blanc_full.png'),
                          width: MediaQuery.of(context).size.width*0.35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Products())
              );
            },
            child: Card(
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Voir tous les produits',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            child: const Text("Catégories"),
          ),
          Expanded(
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 3,
              children: _buildGridView(Constants.categories)
            ),
          )
        ],
      ),
    );
  }

  _updateProductsNumber(){
    _productsStream.count().get() .then(
          (res) => setArticlesNum(res.count),
      onError: (e) => null,
    );
  }

  setArticlesNum(int val){
    setState(() {
      productCount = val;
    });
  }
  aaa(){
    var aa = _productsStream.count().get();
    print(aa);
  }

  List<Widget> _buildGridView(List categories){
    List<Widget> gridItems = [];
    for (String category in categories){
      gridItems.add(CustomMenuTile(title: category, pic: AssetImage("assets/icons/${category.toLowerCase()}.png")));
    }
    return gridItems;
  }
}

