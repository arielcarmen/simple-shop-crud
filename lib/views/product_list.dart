import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m_ola/utils/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../widgets/show_product_details.dart';
import 'add_form.dart';
import 'edit_form.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');
  late final SharedPreferences prefs;
  bool isAdmin = false;

  @override
  void initState() {
    _getSharedPreferences();
    super.initState();
  }

  _getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('admin') && prefs.getBool('admin')!){
      setState(() {
        isAdmin = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream.where("category", isEqualTo: widget.category).snapshots(),
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
            return ListView(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs
                  .map( (DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                    child: GestureDetector(
                      onDoubleTap: (){
                        if (isAdmin){
                          Product sProduct = Product(data['name'], data['details'], data['price'],
                              data['category'], data['url'], data['added_by'], data['edited_by']);
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProductEditForm(documentId: document.id,product: sProduct))
                          );
                        }
                      },
                      onLongPress: (){
                        if (isAdmin){
                          showDeleteDialog(context, document, data['name']);
                        }
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        onTap: (){
                          Product sProduct = Product(data['name'], data['details'], data['price'], data['category'], data['url'], data['added_by'], data['edited_by']);
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
                        trailing: Text(
                            '${data['price']}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: Colors.redAccent
                          ),
                        ),
                        title: Text(data['name']),
                      ),
                    ),
                  ),
                );
              }).toList().cast(),
            );
          } else {
            return const Center(child: Text("Une erreur s'est produite"));
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: isAdmin,
        child: FloatingActionButton(
          onPressed: () async {
            // await showAddDialog(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddForm(category: widget.category,))
            );
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
          ),
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context, DocumentSnapshot document, String name) async{
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  title: const Text('Confirmation'),
                  content: const Text('Voulez vous supprimer cet article ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _productsStream.doc(document.id).delete().then((value) => Navigator.of(context).pop())
                            .then(
                              (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name supprimé'))),
                          onError: (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e error'))),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          "Supprimer",
                          style: TextStyle(
                              color: Colors.red
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
          );
        }
    );
  }

}
