import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  @override
  void dispose() {
    // TODO: implement dispose
    tPrice.dispose();
    tName.dispose();
    tDescription.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController tName = TextEditingController();
  final TextEditingController tPrice = TextEditingController();
  final TextEditingController tDescription = TextEditingController();
  final List<String> categories = ['Cheveux','Savons','Peau','Accessoires','À porter','Outils','Autres'];

  var db = FirebaseFirestore.instance;
  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');
  String dropdownvalue = 'Cheveux';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    labelText: ('Nom'),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1
                        )
                    )
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField(
                value: dropdownvalue,
                items: categories.map((category){
                  return DropdownMenuItem(
                    value: category,
                    child: Text('$category'),
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
                    dropdownvalue = newValue!.toString();
                  });
                },
              ),
              const SizedBox(
                height: 5,
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
                    labelText: ('Prix'),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1
                        )
                    )
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: tDescription,
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: ('Details'),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1
                        )
                    )
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('Ajouter'),
                    onPressed: () async {
                      if( _formKey.currentState!.validate()){
                        await addProduct(tName.text, tDescription.text, int.parse(tPrice.text), "url", dropdownvalue, "added_by", "edited_by")
                            .then((value) => tName.clear())
                            .then((value) => tPrice.clear())
                            .then((value) => tDescription.clear())
                            .then((value) => setState);
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Arrêter'),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> addProduct(name, details, price, url, category, added_by, edited_by) async {
    final Product article = Product(name, details, price, category, url, added_by, edited_by);
    db.collection('articles')
        .add(article.toMap())
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${article.name} ajouté !'))))
        .then((value) => tName.clear())
        .then((value) => tPrice.clear())
        .then((value) => tDescription.clear()).onError((error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur'))));
  }
}
