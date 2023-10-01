import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../utils/tools.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  late User _user;
  @override
  void initState() {
    _user = getLoggedInUser();
    super.initState();
  }
  @override
  void dispose() {
    tPrice.dispose();
    tName.dispose();
    tDescription.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController tName = TextEditingController();
  final TextEditingController tPrice = TextEditingController();
  final TextEditingController tDescription = TextEditingController();
  var db = FirebaseFirestore.instance;
  String dropdownValue = 'Laits';

  static const double _separator = 15.0;

  @override
  Widget build(BuildContext context) {
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
                      // DropdownButtonFormField(
                      //   value: dropdownValue,
                      //   items: Constants.categories.map((category){
                      //     return DropdownMenuItem(
                      //       value: category,
                      //       child: Text(category),
                      //     );
                      //   }).toList(),
                      //   style: const TextStyle(fontSize: 15, color: Colors.black),
                      //   isExpanded: true,
                      //   borderRadius: BorderRadius.circular(5),
                      //   decoration: const InputDecoration(
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               width: 1,
                      //               color: Colors.pink
                      //           )
                      //       )
                      //   ),
                      //   onChanged: (Object? newValue) {
                      //     setState(() {
                      //       dropdownValue = newValue!.toString();
                      //     });
                      //   },
                      // ),
                      Text('Ajouter dans : ${widget.category} '),
                      const SizedBox(
                        height: _separator,
                      ),
                      TextFormField(
                        controller: tName,
                        inputFormatters: <TextInputFormatter>[
                          UpperCaseTextFormatter()
                        ],
                        validator: (value){
                          return value!.isNotEmpty ? null : "Nom obligatoire";
                        },
                        keyboardType: TextInputType.name,
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
                      const SizedBox(height: _separator),
                      TextFormField(
                        controller: tPrice,
                        validator: (value){
                          return value!.isNotEmpty ? null : "Prix obligatoire";
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            suffixText: ('FCFA'),
                            labelText: ('Prix unitaire'),
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
                            child: const Text('Ajouter'),
                            onPressed: () async {
                              if( _formKey.currentState!.validate()){
                                await addProduct(tName.text, tDescription.text, int.parse(tPrice.text), "url", widget.category, _user.displayName, "no one")
                                    .then((value) => tName.clear())
                                    .then((value) => tPrice.clear())
                                    .then((value) => tDescription.clear())
                                    .then((value) => setState);
                              }
                            },
                          ),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //       primary: Colors.red,
                          //       onPrimary: Colors.white
                          //   ),
                          //   onPressed: () async {
                          //     Navigator.of(context).pop();
                          //   },
                          //   child: const Text('Arrêter'),
                          // )
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

  Future<void> addProduct(name, details, price, url, category, addedBy, editedBy) async {
    if(details == ""){
      details = "Aucune note";
    }
    final Product article = Product(name, details, price, category, url, addedBy, editedBy);
    db.collection('articles')
        .add(article.toMap())
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${article.name} ajouté !'), duration: Duration(milliseconds: 800),)))
        .then((value) => tName.clear())
        .then((value) => tPrice.clear())
        .then((value) => tDescription.clear()).onError((error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur'))));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

