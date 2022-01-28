// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:grocery_app/services/db_service.dart';

import '../Models/grocery_item.dart';

class GroceryList with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }

  int get length {
    return _items.length;
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }
}

final groceryListProvider =
    StreamProvider<List<Item>>((ref) => DatabaseService().getGroceryItems());
