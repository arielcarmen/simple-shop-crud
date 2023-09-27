import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
    );
  }
}
