import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../GetXClass.dart';
import 'Homepage.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  RxString _imagepath = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Text(
              "Register",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "Create your account",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Username
            const SizedBox(height: 35),
            Obx(
              () => TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  errorText: GetXClass.isValidUsername.value
                      ? null
                      : "please enter user name",
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Email
            const SizedBox(height: 10),
            Obx(
              () => TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText:
                      GetXClass.isValidEmial.value ? null : "Enter valid email",
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
                controller: _controllerPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  errorText: GetXClass.isValidPassword.value
                      ? null
                      : "Please enter the password",
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {},
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

            // Confirm Password
            const SizedBox(height: 10),
            Obx(
              () => TextFormField(
                controller: _controllerConFirmPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  errorText: GetXClass.isValidRePassword.value
                      ? null
                      : "Password doesn't match",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Image Picker
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Obx(
                  () => Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                      image: _imagepath.value.isEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/default_image.jpg'),
                            )
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File("${_imagepath.value}"),
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      _imagepath.value = image!.path;
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            // Register Button
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                GetXClass.isValidUsername.value =
                    _controllerUsername.text.isNotEmpty;
                GetXClass.isValidEmial.value =
                    _controllerEmail.text.isNotEmpty &&
                        GetXClass.emailRegexp.hasMatch(_controllerEmail.text);
                GetXClass.isValidPassword.value = _controllerPassword
                        .text.isNotEmpty &&
                    _controllerConFirmPassword.text == _controllerPassword.text;
                GetXClass.isValidRePassword.value = _controllerPassword
                        .text.isNotEmpty &&
                    _controllerConFirmPassword.text == _controllerPassword.text;

                if (GetXClass.isValidUsername.value &&
                    GetXClass.isValidEmial.value &&
                    GetXClass.isValidPassword.value &&
                    GetXClass.isValidRePassword.value) {
                  String image = "";
                  String imageName = "";

                  if (_imagepath.value.isNotEmpty) {
                    image = base64Encode(
                        (await File(_imagepath.value).readAsBytes()));
                    imageName = "img${DateTime.now().second}${DateTime.now()}";
                  }

                  Map body = {
                    "name": _controllerUsername.text,
                    "email": _controllerEmail.text,
                    "password": _controllerPassword.text,
                    "image": image,
                    "imageName": imageName
                  };

                  var url = Uri.parse(
                      'https://gunjanecommapp.000webhostapp.com/register.php');
                  var response = await http.post(url, body: body);
                  GetXClass.prefs?.setBool("isLogin", true);
                  Get.offAll(Homepage());
                }
              },
              child: const Text("Register Now"),
            ),

            // Login Button
            const SizedBox(height: 50),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        GetXClass.isValidUsername.value = true;
                        GetXClass.isValidEmial.value = true;
                        GetXClass.isValidPassword.value = true;
                        GetXClass.isValidRePassword.value = true;
                        GetXClass.isValidDOB.value = true;
                        Get.off(LoginPage());
                      },
                      child: const Text("Login"),
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
