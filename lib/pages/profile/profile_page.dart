import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/GetXClass.dart';
import 'package:online_shopping_app/constants.dart';
import 'package:online_shopping_app/pages/profile/components/profile_menu.dart';
import 'package:online_shopping_app/pages/profile/components/profile_pic.dart';
import 'package:http/http.dart' as http;

import '../login/login_page.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ProfilePic(
                    profileImage: snapshot.data!["userData"][0]["image"],
                  ),
                  const SizedBox(height: 20),
                  ProfileMenu(
                    text: snapshot.data!["userData"][0]["username"],
                    icon: "assets/icons/User Icon.svg",
                    press: () => {},
                  ),
                  ProfileMenu(
                    text: snapshot.data!["userData"][0]["email"],
                    icon: "assets/icons/Email.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                    text: snapshot.data!["userData"][0]["password"],
                    icon: "assets/icons/Lock.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Log Out",
                    icon: "assets/icons/Log out.svg",
                    press: () {
                      GetXClass.prefs?.setBool("isLogin", false);
                      GetXClass.prefs?.setString("userid", "");
                      Get.offAll(LoginPage());
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map> getUserData() async {
    var url =
        Uri.parse("https://gunjanecommapp.000webhostapp.com/get_user_data.php");
    var response = await http
        .post(url, body: {"user_id": GetXClass.prefs!.getString("userid")});
    var userData = jsonDecode(response.body);
    return userData;
  }
}
