import 'package:flutter/material.dart';
import '../../../constants.dart';

class CartCard extends StatelessWidget {
  String image;
  String name;
  String price;
  String id;

  CartCard({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(image),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "\$${price}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            ),
            Text("Transaction id:"),
            Text(
              id,
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
          ],
        )
      ],
    );
  }
}
