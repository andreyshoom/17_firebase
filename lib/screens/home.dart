import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/model/shopping_action.dart';
import 'package:shopping_list/model/shopping_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _editingController = TextEditingController();
  String newPurchase = '';
  final storage = FirebaseStorage.instance;
  late CollectionReference<ShoppingList> _reference;

  @override
  void initState() {
    super.initState();
    _reference = FirebaseFirestore.instance
        .collection('shopping')
        .withConverter<ShoppingList>(
          fromFirestore: (snapshot, _) {
            // print(snapshot.data());
            return ShoppingList.fromJson(snapshot.data()!);
          },
          toFirestore: (purchase, _) =>
              purchase.toJson() as Map<String, Object?>,
        );

    _editingController.addListener(() {
      newPurchase = _editingController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  void _submit() {
    setState(() {
      _reference.add(ShoppingList(
        purchaseItem: _editingController.text,
        isBought: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _addPurchase() async {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add a new purchase'),
          content: TextFormField(
            autofocus: true,
            controller: _editingController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _submit();
                // context.read<ShoppingList>().addPurchase(newPurchase);
                Navigator.pop(context);
                _editingController.clear();
              },
              child: const Text('Submit'),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping list'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list_rounded,
            ),
          )
        ],
      ),
      body: FutureBuilder<String>(
        future: storage.ref('shop.png').getDownloadURL(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.1), BlendMode.dstATop),
                        image: NetworkImage(snapshot.data!),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    // child: ShoppingAction(
                    //   list: _reference,
                    // ),
                    child: StreamBuilder<List<ShoppingList>>(
                      stream: _reference.snapshots().map(
                            (event) => event.docs.map((e) => e.data()).toList(),
                          ),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        return Container();
                      },
                    ),
                  )
                : const SizedBox(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPurchase,
        label: Row(
          children: const [
            Icon(Icons.add),
            Text('Add a purchase'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
