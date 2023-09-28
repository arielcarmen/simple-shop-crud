import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m_ola/utils/tools.dart';

import '../models/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');

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
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs
                  .map( (DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                      onLongPress: (){
                        // showDeleteDialog(context, document, data['name']);
                      },
                      onTap: (){
                        Product sProduct = Product(data['name'], data['details'], data['price'], data['category'], data['url'], data['added_by'], data['edited_by']);
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(db: db, documentId: document.id,product: sProduct,)));
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: productImage(data['url'],data['category']),
                      ),
                      trailing: Text('${data['price']}'),
                      title: Text(data['name']),
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
    );
  }
}
