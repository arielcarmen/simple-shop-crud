import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m_ola/models/product.dart';

class DatabaseService{
  final String collectionPath = 'path';
  final CollectionReference productsCollection = FirebaseFirestore.instance.collection("articles");

  List<Object?> articlesFromSnapshot(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) => e.data()).toList();
  }
}

