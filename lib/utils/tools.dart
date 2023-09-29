import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget productImage(String url, String category){
  return url == "url"  ? Image.asset('assets/icons/${category.toLowerCase()}.png', height: 30, width: 30,)
      : Image.network(url, height: 30, width: 30,);
}

class BlueTheme {
  static const MaterialColor blueTint = MaterialColor(
    0xffd1f3ec,
    <int, Color>{
      50: Color(0xffd1f3ec),//10%
      100: Color(0xffbcdbd4),//20%
      200: Color(0xffa7c2bd),//30%
      300: Color(0xff92aaa5),//40%
      400: Color(0xff7d928e),//50%
      500: Color(0xff697a76),//60%
      600: Color(0xff54615e),//70%
      700: Color(0xff3f4947),//80%
      800: Color(0xff2a312f),//90%
      900: Color(0xff151818),//100%
    },
  );
}
