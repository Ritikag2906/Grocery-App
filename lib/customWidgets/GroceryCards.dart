import 'package:flutter/material.dart';
import 'package:grocery_app/customWidgets/ClipRRectCustom.dart';
import 'package:grocery_app/utils/widgetConstants.dart';

class GroceryCards extends StatelessWidget {
  final String title, price, image, quantity;

  const GroceryCards({
    Key? key,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-0.6, -0.6),
            blurRadius: 3,
            color: Colors.grey,
          ),
        ],
        color: Colors.white,
      ),
      child: Stack(children: [
        ClipRRectCustom(image: image, height: 180),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Container(
                color: Colors.black87.withOpacity(0.8),
                height: height * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$ $price",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )),
      ]),
    );
  }
}
