import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/pages/Homepage.dart';
import 'package:http/http.dart' as http;
import '../../../GetXClass.dart';
import '../../../widgets/custome_suffix_icon.dart';
import '../../../widgets/form_error.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? username;
  bool? remember = false;
  final RxList errors = [].obs;
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  Map userData = {};

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
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
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => username = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: "Please Enter your username");
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: "Please Enter your email");
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
              suffixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: "Please Enter your email");
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: "Please Enter your password");
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: "Please Enter your email");
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: "Please Enter Valid Email");
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
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: "Please Enter your password");
              } else if (value.length > 3) {
                removeError(error: "Password is too short");
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: "Please Enter your password");
                return "";
              } else if (value.length < 3) {
                addError(error: "Password is too short");
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
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: Color(0xFFFF7643),
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
            ],
          ),
          Obx(() => FormError(errors: errors.value)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
                Map loginapi = {'email': email, 'password': password};

                // get user data
                var url = Uri.parse(
                    'https://gunjanecommapp.000webhostapp.com/select_user_data.php');
                var response = await http.post(url, body: loginapi);

                String strResponse = response.body;
                userData = jsonDecode(strResponse);

                // print('userdata: ${userData["userData"]}');
                if (userData["userData"].isEmpty) {
                  const snackBar = SnackBar(
                    content: Text('No data found, pleas register'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  print("pass: ${userData["userData"][0]["password"]}");
                  if (userData["userData"][0]["password"] == password) {
                    GetXClass.prefs?.setBool("isLogin", true);
                    GetXClass.prefs
                        ?.setString("userid", userData["userData"][0]["id"]);
                    Get.offAll(Homepage());
                  } else {
                    GetXClass.isValidPasswordLogin.value = false;
                  }
                }
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
