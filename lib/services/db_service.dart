import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/Models/grocery_item.dart';

class DatabaseService{
  Stream<List<Item>> getGroceryItems() {
    final CollectionReference ref = FirebaseFirestore.instance.collection('grocery');
        

    return ref
        .orderBy(
          'id',
          descending: true,
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => Item.fromMap(e.data()! as Map<String, dynamic>))
            .toList());
  }
}