import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String docId;
  final DateTime id;
  final String name;
  final String imagePath;
  final double price;
  final int quantity;

  Item({
    required this.docId,
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'id': id.millisecondsSinceEpoch,
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map, String docId1) {
    return Item(
      docId: docId1,
      id: DateTime.parse(map['id']),
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Item &&
      other.docId == docId &&
      other.id == id &&
      other.name == name &&
      other.imagePath == imagePath &&
      other.price == price &&
      other.quantity == quantity;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
      id.hashCode ^
      name.hashCode ^
      imagePath.hashCode ^
      price.hashCode ^
      quantity.hashCode;
  }

  Item copyWith({
    String? docId,
    DateTime? id,
    String? name,
    String? imagePath,
    double? price,
    int? quantity,
  }) {
    return Item(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
