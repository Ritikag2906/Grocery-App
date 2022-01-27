import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final DateTime id;
  final String name;
  final String imagePath;
  final double price;
  final int quantity;

  Item({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: (map['lastUpdated'] as Timestamp).toDate(),
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(id: $id, name: $name, imagePath: $imagePath, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imagePath.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}
