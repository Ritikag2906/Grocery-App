import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/utils/widgetConstants.dart';
import 'package:shimmer/shimmer.dart';

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
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 200,
              color: Colors.white,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: widget.image,
                placeholder: (context, url) => SizedBox(
                  height: 200,
                  child: Shimmer.fromColors(
                    baseColor: GlobalColors.primaryColor.withOpacity(0.1),
                    highlightColor: Colors.white,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Icon(Icons.image, size: 40),
                        ClipRRect(
                          // Clip it cleanly.
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Stack(
                  fit: StackFit.expand,
                  children: [
                    const Icon(Icons.hide_image, size: 40),
                    ClipRRect(
                      // Clip it cleanly.
                      child: Container(
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Row(
          children: [
            Text("Price : " + widget.price),
            Text("Qty : " + widget.quantity)
          ],
        )
      ],
    );
  }
}
