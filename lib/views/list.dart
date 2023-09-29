
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:m_ola/models/product.dart';
import 'package:flutter/material.dart';
import 'package:m_ola/utils/tools.dart';
import 'package:m_ola/views/add_form.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
  String dropdownvalue = 'Cheveux';
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    const source = Source.cache;
  }

  Future<void> showAddDialog(BuildContext context) async{
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter des articles'),
              content: Form(
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
            );
          }
        );
      }
    );
  }

  Future<void> showDeleteDialog(BuildContext context, DocumentSnapshot document, String name) async{
    return await showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  title: const Text('Suppression'),
                  content: const Text('Voulez vous supprimer cet article ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        db.collection("articles").doc(document.id).delete().then((value) => Navigator.of(context).pop())
                            .then(
                              (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name supprimé'))),
                          onError: (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e error'))),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(14),
                        child: const Text("Supprimer"),
                      ),
                    ),
                  ],
                );
              }
          );
        }
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

  final CollectionReference _productsStream = FirebaseFirestore.instance.collection('articles');

  final searchText = ValueNotifier<String>('');

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: _searchController,
          backgroundColor: Colors.white,
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream.snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData || snapshot.data!.docs.toList().isEmpty){
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage(
                      "assets/icons/no_product.png",
                    ),
                    height: 100,
                  ),
                  Text(
                    'Aucun article',
                    style: TextStyle(
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            );
          } else if(snapshot.hasError){
            return const Center(
              child: Text('Erreur article'),
            );
          } else if(snapshot.hasData){
            return ListView(
              children: snapshot.data!.docs
                    .map( (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          onLongPress: (){
                            showDeleteDialog(context, document, data['name']);
                          },
                          onTap: (){
                            Product sProduct = Product(data['name'], data['details'], data['price'], data['category'], data['url'], data['added_by'], data['edited_by']);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(db: db, documentId: document.id,product: sProduct,)));
                          },
                           leading: ClipRRect(
                             borderRadius: BorderRadius.circular(8),
                             child: productImage(data['url'],data['category']),
                           ),
                          trailing: Text('${data['price']}'),
                          title: Text(data['name']),
                          subtitle: Text('${data['category']}'),
                           ),
                      ),
                    );
              }).toList().cast(),
            );
          } else {
            return const Center(child: Text("Une erreur s'est produite"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          // await showAddDialog(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddForm())
          );
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
