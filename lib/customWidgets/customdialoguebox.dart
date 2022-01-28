import 'package:flutter/material.dart';
import 'package:grocery_app/customWidgets/ClipRRectCustom.dart';
import 'package:grocery_app/pages/EditPage.dart';
import 'package:grocery_app/utils/widgetConstants.dart';

class CustomDialogueBox extends StatefulWidget {
  final String image, price, quantity;
  const CustomDialogueBox(
      {Key? key,
      required this.image,
      required this.price,
      required this.quantity})
      : super(key: key);

  @override
  CustomDialogueBoxState createState() => CustomDialogueBoxState();
}

class CustomDialogueBoxState extends State<CustomDialogueBox> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ClipRRectCustom(
          image: widget.image,
          height: 200,
          width: 200,
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Price : " + widget.price,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Qty : " + widget.quantity,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditPage()))
                  .then((value) => Navigator.pop(context));
            },
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: GlobalColors.primaryColor,
                minimumSize: Size(width * 0.5, 30))),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(width * 0.5, 30))),
      ],
    );
  }
}
