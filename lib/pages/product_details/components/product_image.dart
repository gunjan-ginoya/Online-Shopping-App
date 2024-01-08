import 'package:flutter/material.dart';

class ProductImages extends StatelessWidget {
  ProductImages({
    Key? key,
    required this.productImage,
  }) : super(key: key);

  final String productImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(productImage),
          ),
        ),
        // SizedBox(height: 20),
      ],
    );
  }
}

