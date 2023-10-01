
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_ola/models/product.dart';
import 'package:flutter/material.dart';
import 'package:m_ola/utils/tools.dart';
import 'package:m_ola/widgets/show_product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var db = FirebaseFirestore.instance;

  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');

  final TextEditingController _searchController = TextEditingController();

  List _productsList = [];
  List _allProducts = [];
  late final SharedPreferences prefs;

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
    getAllProducts();
  }

  void _onSearchChanged(){
    List searchResults = [];
    if (_searchController.text != ""){
      for (var snapshot in _allProducts){
        var name = snapshot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())){
          searchResults.add(snapshot);
        }
      }
    } else {
      searchResults = List.from(_allProducts);
    }

    setState(() {
      _productsList = searchResults;
    });
  }

  getAllProducts() async {
    prefs = await SharedPreferences.getInstance();
    var data = await _productsStream.orderBy('name').get();
    setState(() {
      _productsList = data.docs;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          placeholder: 'Rechercher',
          controller: _searchController,
          backgroundColor: Colors.white,
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream.orderBy('name').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData || snapshot.data!.docs.toList().isEmpty){
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage(
                      "assets/icons/no_product.png",
                    ),
                    height: 100,
                  ),
                  Text(
                    'Aucun article',
                    style: TextStyle(
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            );
          } else if(snapshot.hasError){
            return const Center(
              child: Text('Erreur article'),
            );
          } else if(snapshot.hasData){
            _allProducts = snapshot.data!.docs.toList();
            // _productsList = _allProducts;
            return
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                physics: const BouncingScrollPhysics(),
              itemCount: _productsList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                    child: GestureDetector(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        onTap: (){
                          Product sProduct = Product(_productsList[index]['name'], _productsList[index]['details'], _productsList[index]['price'], _productsList[index]['category'],
                              _productsList[index]['url'], _productsList[index]['added_by'], _productsList[index]['edited_by']);
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: ProductDetails(product: sProduct),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                );
                              }
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: productImage(_productsList[index]['url'],_productsList[index]['category']),
                        ),
                        trailing: Text(
                            '${_productsList[index]['price']}f',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        title: Text(_productsList[index]['name']),
                        subtitle: Text('${_productsList[index]['category']}'),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Une erreur s'est produite"));
          }
        },
      ),

    );
  }

}
