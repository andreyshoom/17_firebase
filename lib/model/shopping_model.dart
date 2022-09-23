import 'package:flutter/cupertino.dart';

const kPurchaseItem = 'purchase';
const kIsBought = false;

class ShoppingList extends ChangeNotifier {
  String purchaseItem;
  bool isBought;

  ShoppingList({required this.purchaseItem, this.isBought = false});

  void toggleBought() {
    isBought = !isBought;
  }

  factory ShoppingList.fromJson(Map<String, Object?> json) => ShoppingList(
      purchaseItem: json[kPurchaseItem] as String,
      isBought: json[kIsBought] as bool);

  Map<dynamic, Object?> toJson() =>
      {kPurchaseItem: purchaseItem, kIsBought: isBought};

  List<ShoppingList> lists = [];

  List<ShoppingList> get items => lists;

  void addPurchase(String purchaseAdd) {
    lists.add(ShoppingList(purchaseItem: purchaseAdd, isBought: false));
    notifyListeners();
  }

  void removePurchase(ShoppingList purchaseRemove) {
    lists.remove(purchaseRemove);
    notifyListeners();
  }

  void togglePurchase(ShoppingList list) {
    final listIndex = lists.indexOf(list);
    lists[listIndex].toggleBought();
    notifyListeners();
  }
}
