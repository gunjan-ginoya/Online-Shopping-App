import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../widgets/custome_suffix_icon.dart';
import '../../../widgets/form_error.dart';

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
  bool remember = false;
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
          Obx(()=> FormError(errors: errors.value)),
          const SizedBox(height: 20),
          // if all are valid then go to success screen
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // TODO: Register User

                //             GetXClass.isValidUsername.value =
                //                 _controllerUsername.text.isNotEmpty;
                //             GetXClass.isValidEmial.value =
                //                 _controllerEmail.text.isNotEmpty &&
                //                     GetXClass.emailRegexp.hasMatch(_controllerEmail.text);
                //             GetXClass.isValidPassword.value = _controllerPassword
                //                     .text.isNotEmpty &&
                //                 _controllerConFirmPassword.text == _controllerPassword.text;
                //             GetXClass.isValidRePassword.value = _controllerPassword
                //                     .text.isNotEmpty &&
                //                 _controllerConFirmPassword.text == _controllerPassword.text;
                //
                //             if (GetXClass.isValidUsername.value &&
                //                 GetXClass.isValidEmial.value &&
                //                 GetXClass.isValidPassword.value &&
                //                 GetXClass.isValidRePassword.value) {
                //               String image = "";
                //               String imageName = "";
                //
                //               if (_imagepath.value.isNotEmpty) {
                //                 image = base64Encode(
                //                     (await File(_imagepath.value).readAsBytes()));
                //                 imageName = "img${DateTime.now().second}${DateTime.now()}";
                //               }
                //
                //               Map body = {
                //                 "name": _controllerUsername.text,
                //                 "email": _controllerEmail.text,
                //                 "password": _controllerPassword.text,
                //                 "image": image,
                //                 "imageName": imageName
                //               };
                //
                //               var url = Uri.parse(
                //                   'https://gunjanecommapp.000webhostapp.com/register.php');
                //               var response = await http.post(url, body: body);
                //               GetXClass.prefs?.setBool("isLogin", true);
                //               Get.offAll(Homepage());

              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
