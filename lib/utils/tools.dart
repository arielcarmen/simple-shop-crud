import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget productImage(String url, String category){
  return url == "url"  ? Image.asset('assets/icons/${category.toLowerCase()}.png', height: 30, width: 30,)
      : Image.network(url, height: 30, width: 30,);
}
