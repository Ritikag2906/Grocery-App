import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/Models/grocery_item.dart';

class DatabaseService {
  Stream<List<Item>> getGroceryItems() {
    final CollectionReference ref =
        FirebaseFirestore.instance.collection('grocery');

    return ref
        .orderBy(
          'id',
          descending: true,
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => Item.fromMap(e.data()! as Map<String, dynamic>, e.id))
            .toList());
  }

  Future<void> addGroceryItem(Item item) async {

    // Reference to the path in firestore where the collection reside.
    final CollectionReference ref =
        FirebaseFirestore.instance.collection('grocery');
    // adding to database
    await ref.add(item.toMap()).catchError((error) {
      debugPrint('Error Occurred: $error');
    });
  }
  Future<void> deleteCollection(String docId) async {
 final CollectionReference ref =
        FirebaseFirestore.instance.collection('grocery');
    await ref.doc(docId).delete();
  }
}

