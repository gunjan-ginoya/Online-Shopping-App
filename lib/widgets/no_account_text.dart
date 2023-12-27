import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/pages/register/register_page.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Get.offAll(RegisterPage()),
          child: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 16, color: Color(0xFFFF7643)),
          ),
        ),
      ],
    );
  }
}
