import 'package:flutter/material.dart';
import 'package:m_ola/models/product.dart';
import 'package:m_ola/utils/tools.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 18,
                  ),
                ),
              ),
              // Expanded(
              //   flex: 4,
              //   child: Text(
              //     "(${product.category})",
              //     style: TextStyle(
              //         fontSize: 10,
              //         color: BlueTheme.blueTint[800]
              //     ),
              //   ),
              // )
            ],
          ),
          Text(
            "${product.price} francs",
            style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 25
            )),
          const Text(
              'Notes',
            style: TextStyle(
              fontSize: 8
            ),
          ),

          Text(product.details),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ajouté par:',
                style: TextStyle(
                    fontSize: 8
                ),
              ),
              Text(
                product.added_by,
                style: const TextStyle(
                    fontSize: 8,
                  color: Colors.red
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
