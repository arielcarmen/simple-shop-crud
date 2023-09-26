import 'package:cloud_firestore/cloud_firestore.dart';

class Product{

  late String name;
  late int price;
  late String url;
  late String details;
  late String category;
  late String added_by;
  late String edited_by;
  Product(this.name, this.details, this.price, this.category, this.url, this.added_by, this.edited_by);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'details': details,
      'url': url,
      'category': category,
      'added_by': added_by,
      'edited_by': edited_by,
    };
  }

  final CollectionReference articles = FirebaseFirestore.instance.collection("articles");

  factory Product.fromDocumentSnapshot({required DocumentSnapshot<Map<String,dynamic>> doc}){
    return Product(doc.data()!["name"],doc.data()!["details"],doc.data()!["price"],doc.data()!["url"],doc.data()!["category"],doc.data()!["added_by"],doc.data()!["edited_by"]);
  }

  List<Product> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return Product(
        dataMap['name'],
        dataMap['details'],
        dataMap['price'],
        dataMap['category'],
        dataMap['url'],
        dataMap['added_by'],
        dataMap['edited_by'],
      );
    }).toList();
  }

}