import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/utils/widgetConstants.dart';
import 'package:shimmer/shimmer.dart';

class ClipRRectCustom extends StatelessWidget {
  final String image;
  final double height;
  const ClipRRectCustom({Key? key, required this.image, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: height,
          color: Colors.white,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: image,
            placeholder: (context, url) => SizedBox(
              height: height,
              child: Shimmer.fromColors(
                baseColor: GlobalColors.primaryColor.withOpacity(0.1),
                highlightColor: Colors.white,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const Icon(Icons.image, size: 40),
                    ClipRRect(
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
                  child: Container(
                    color: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
