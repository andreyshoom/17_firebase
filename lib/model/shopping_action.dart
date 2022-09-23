import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/model/shopping_model.dart';

class ShoppingAction extends StatelessWidget {
  ShoppingAction({Key? key, required this.list}) : super(key: key);
  final CollectionReference<ShoppingList> list;

  @override
  Widget build(BuildContext context) {
    final purchase = context.read<ShoppingList>();
    return StreamBuilder<List<ShoppingList>>(
      stream: list.snapshots().map(
            (event) => event.docs.map((e) => e.data()).toList(),
          ),
      builder: (context, snapshot) => Consumer<ShoppingList>(
        builder: (context, value, child) => ListView.builder(
          itemCount: context.read<ShoppingList>().items.length,
          itemBuilder: (context, index) => Column(
            children: [
              ListTile(
                leading: Checkbox(
                    value: purchase.items[index].isBought,
                    onChanged: (context) {
                      purchase.togglePurchase(purchase.items[index]);
                    }),
                title: !purchase.items[index].isBought
                    ? Text(
                        purchase.items[index].purchaseItem,
                      )
                    : Text.rich(
                        TextSpan(
                          text: purchase.items[index].purchaseItem,
                          style: TextStyle(
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 5,
                          ),
                        ),
                      ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: !purchase.items[index].isBought
                        ? Colors.grey
                        : Colors.red,
                  ),
                  onPressed: () {
                    purchase.removePurchase(purchase.items[index]);
                  },
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
