import 'package:flutter/material.dart';
import 'package:m_ola/views/product_list.dart';


class CustomMenuTile extends StatelessWidget {
  const CustomMenuTile({Key? key, required this.title, required this.pic}) : super(key: key);
  final String title;
  final AssetImage pic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductList(category: title))
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: pic,
              height: 50,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
