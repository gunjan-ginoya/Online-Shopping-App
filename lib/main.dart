import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/pages/check_login.dart';
import 'package:online_shopping_app/theme.dart';

void main() {
  runApp(const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      home: checklogin(),
    );
  }
}
