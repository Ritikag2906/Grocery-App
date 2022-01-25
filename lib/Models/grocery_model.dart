import 'dart:convert';

List<GroceryModel> groceryFromJson(String str) => List<GroceryModel>.from(
    json.decode(str).map((x) => GroceryModel.fromJson(x)));

String groceryToJson(List<GroceryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class GroceryModel {
  String? name;
  String? image;
  String? price;

  GroceryModel({this.name, this.image, this.price});

  GroceryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}