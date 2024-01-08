import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_shopping_app/pages/login/login_page.dart';
import '../../../GetXClass.dart';
import '../../../constants.dart';
import '../../../widgets/custome_suffix_icon.dart';
import '../../../widgets/form_error.dart';
import '../../Homepage.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? username;
  String? conform_password;
  RxString _imagepath = "".obs;
  bool remember = false;
  RxBool isLoading = false.obs;
  final RxList errors = [].obs;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Profile Image
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
          const SizedBox(height: 30),
          // Username
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => username = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: "Please Enter Your Username");
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: "Please Enter Your Username");
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Username",
              hintText: "Enter your username",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/user.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Email
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Password
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // Confirm password
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => conform_password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.isNotEmpty && password == conform_password) {
                removeError(error: kMatchPassError);
              }
              conform_password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if ((password != value)) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          Obx(() => FormError(errors: errors.value)),
          const SizedBox(height: 20),
          // if all are valid then go to success screen
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                isLoading.value = true;
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // TODO: Register User

                  String image = "";
                  String imageName = "";

                  if (_imagepath.value.isNotEmpty) {
                    image = base64Encode(
                        (await File(_imagepath.value).readAsBytes()));
                    imageName = "img${DateTime.now().second}${DateTime.now()}";
                  }
                  Map body = {
                    "name": username!.trim(),
                    "email": email!.trim(),
                    "password": password!.trim(),
                    "image": image,
                    "imageName": imageName
                  };

                  var url = Uri.parse(
                      'https://gunjanecommapp.000webhostapp.com/register.php');

                  var response = await http.post(url, body: body);
                  GetXClass.prefs?.setBool("isLogin", true);
                  Get.offAll(LoginPage());
                }
                isLoading.value = false;
              },
              child: isLoading.value
                  ? Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
