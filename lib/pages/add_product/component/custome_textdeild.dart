import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomeTextfeild extends StatelessWidget {
  CustomeTextfeild({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    required this.error,
    required this.keyboardType,
  });

  TextEditingController controller;
  final String title;
  final String hintText;
  final Widget error;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        obscureText: false,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title.trim(),
          hintText: hintText.trim(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          error: error
        ),
      ),
    );
  }
}
