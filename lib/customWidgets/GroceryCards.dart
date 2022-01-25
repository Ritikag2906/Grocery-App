import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/utils/widgetConstants.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:shimmer/shimmer.dart';

class GroceryCards extends StatelessWidget {
  final String title, price, image;

  const GroceryCards({
    Key? key,
    required this.title,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 200,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: image,
              placeholder: (context, url) => SizedBox(
                height: 200,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey,
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
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: Container(
              color: GlobalColors.secondaryColor.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(title),
                  Text(price),
                ],
              ),
            ),
          )),
    ]);
  }
}
