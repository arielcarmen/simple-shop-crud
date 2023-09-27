import 'package:flutter/material.dart';

class CustomProductTile extends StatelessWidget {
  const CustomProductTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.fromLTRB(15, 6, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
          )
        ],
      ),
    );
  }

  Widget productImage(String url){
    return url == "url"  ? Image.asset('assets/icons/cleansing.png', height: 50,) : Image.network(url, height: 50,);
  }
}
