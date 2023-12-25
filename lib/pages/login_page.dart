import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/pages/register_page.dart';
import 'package:http/http.dart' as http;
import '../GetXClass.dart';
import 'Homepage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  RxBool isPassword = true.obs;
  Map userData = {};

  @override
  Widget build(BuildContext context) {
    // GetXClass.getSharedPref();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Text(
              "Login",
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            // Email
            const SizedBox(height: 20),
            Obx(
              () => TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: GetXClass.isValidEmailLogin.value
                      ? null
                      : "Enter valid email",
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Password
            const SizedBox(height: 10),
            Obx(
              () => TextFormField(
                obscureText: isPassword.value,
                controller: _controllerPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  errorText: GetXClass.isValidPasswordLogin.value
                      ? null
                      : "Please enter the password",
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      isPassword.value = !isPassword.value;
                    },
                    icon: const Icon(Icons.visibility_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Login Button
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                GetXClass.isValidPasswordLogin.value =
                    _controllerPassword.text.isNotEmpty;
                GetXClass.isValidEmailLogin.value =
                    _controllerEmail.text.isNotEmpty &&
                        GetXClass.emailRegexp.hasMatch(_controllerEmail.text);

                if (GetXClass.isValidPasswordLogin.value &&
                    GetXClass.isValidEmailLogin.value) {

                  Map loginapi = {
                    'email': _controllerEmail.text,
                    'password': _controllerPassword.text
                  };

                  // get user data
                  var url = Uri.parse('https://gunjanecommapp.000webhostapp.com/select_user_data.php');
                  var response = await http.post(url, body: loginapi);

                  String strResponse = response.body;
                  userData = jsonDecode(strResponse);

                  // print('userdata: ${userData["userData"]}');
                  if(userData["userData"].isEmpty){
                    print("NO USer Found");
                    const snackBar = SnackBar(
                      content: Text('No data found, pleas register'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    print("pass: ${userData["userData"][0]["password"] }");
                    if(userData["userData"][0]["password"] == _controllerPassword.text){
                      GetXClass.prefs?.setBool("isLogin", true);
                      Get.offAll(Homepage());
                    }else{
                      GetXClass.isValidPasswordLogin.value = false;
                    }
                  }
                }
              },
              child: const Text("Log in"),
            ),

            // Register Button
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        GetXClass.isValidPasswordLogin.value = true;
                        GetXClass.isValidEmailLogin.value = true;
                        Get.off(RegisterPage());
                      },
                      child: const Text("Register Now"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
