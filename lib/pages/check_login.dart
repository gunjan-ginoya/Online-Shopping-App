import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/GetXClass.dart';
import 'package:online_shopping_app/constants.dart';
import 'package:online_shopping_app/pages/Homepage.dart';
import 'package:online_shopping_app/pages/login/login_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class checklogin extends StatelessWidget {
  checklogin({super.key});

  @override
  Widget build(BuildContext context) {
    GetXClass.getSharedPref();
    Get.put(GetXClass());
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        bool val = GetXClass.prefs!.getBool("isLogin") ?? false;
        if (val) {
          Get.offAll(Homepage());
        } else {
          Get.offAll(LoginPage());
        }
      },
    );
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.waveDots(
          color: kPrimaryColor,
          size: 20,
        ),
      ),
    );
  }
}
