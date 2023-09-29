import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m_ola/models/product.dart';
import 'package:m_ola/utils/tools.dart';

class ProductEditForm extends StatefulWidget {
  const ProductEditForm({Key? key, required this.product, required this.documentId}) : super(key: key);
  final Product product;
  final String documentId;

  @override
  State<ProductEditForm> createState() => _ProductEditFormState();
}

class _ProductEditFormState extends State<ProductEditForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController tName;
  late final TextEditingController tPrice;
  late final TextEditingController tDescription;
  String dropdownValue = "";

  static const double _separator = 15.0;

  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.product.category;
    tName = TextEditingController(text: widget.product.name);
    tPrice = TextEditingController(text: widget.product.price.toString());
    tDescription = TextEditingController(text: widget.product.details);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/logos/logo_blanc.png"),
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: tName,
                        validator: (value){
                          return value!.isNotEmpty ? null : "Nom obligatoire";
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: ('Nouveau nom'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1
                                )
                            )
                        ),
                      ),
                      const SizedBox(
                        height: _separator,
                      ),
                      DropdownButtonFormField(
                        value: dropdownValue,
                        items: Constants.categories.map((category){
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(5),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pink
                                )
                            )
                        ),
                        onChanged: (Object? newValue) {
                          setState(() {
                            dropdownValue = newValue!.toString();
                          });
                        },
                      ),
                      const SizedBox(
                        height: _separator,
                      ),
                      TextFormField(
                        controller: tPrice,
                        validator: (value){
                          return value!.isNotEmpty ? null : "Prix obligatoire";
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: const InputDecoration(
                            suffixText: ('FCFA'),
                            labelText: ('Nouveau prix'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1
                                )
                            )
                        ),
                      ),
                      const SizedBox(
                        height: _separator,
                      ),
                      TextFormField(
                        controller: tDescription,
                        maxLines: 4,
                        minLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: ('Notes'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1
                                )
                            )
                        ),
                      ),
                      const SizedBox(
                        height: _separator,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: const Text('Modifier'),
                            onPressed: () async {
                              if( _formKey.currentState!.validate()){
                                await editProduct(widget.documentId ,tName.text, tDescription.text, int.parse(tPrice.text), dropdownValue, "edited_by")
                                    .then((value) => tName.clear())
                                    .then((value) => tPrice.clear())
                                    .then((value) => tDescription.clear())
                                    .then((value) => setState);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editProduct(documentId, name, details, int price, category, editedBy) async {
    _productsStream.doc(documentId)
        .update({"name": name, "details": details,"price": price,"category": category,"edited_by": "true",
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name modifié !')))).onError((error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur')))).then((value) => Navigator.of(context).pop());
  }
}


