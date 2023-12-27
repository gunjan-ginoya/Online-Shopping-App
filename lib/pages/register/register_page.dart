import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import 'component/sign_up_form.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Register Account", style: headingStyle),
                  const Text(
                    "Complete your details or continue \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignUpForm(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SingleChildScrollView(
    //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
    //     child: Column(
    //       children: [
    //         const SizedBox(height: 100),
    //         Text(
    //           "Register",
    //           style: Theme.of(context).textTheme.headlineLarge,
    //         ),
    //         const SizedBox(height: 10),
    //         Text(
    //           "Create your account",
    //           style: Theme.of(context).textTheme.bodyMedium,
    //         ),
    //
    //         // Username
    //         const SizedBox(height: 35),
    //         Obx(
    //           () => TextFormField(
    //             controller: _controllerUsername,
    //             keyboardType: TextInputType.name,
    //             decoration: InputDecoration(
    //               errorText: GetXClass.isValidUsername.value
    //                   ? null
    //                   : "please enter user name",
    //               labelText: "Username",
    //               prefixIcon: const Icon(Icons.person_outline),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //             ),
    //           ),
    //         ),
    //
    //         // Email
    //         const SizedBox(height: 10),
    //         Obx(
    //           () => TextFormField(
    //             controller: _controllerEmail,
    //             keyboardType: TextInputType.emailAddress,
    //             decoration: InputDecoration(
    //               errorText:
    //                   GetXClass.isValidEmial.value ? null : "Enter valid email",
    //               labelText: "Email",
    //               prefixIcon: const Icon(Icons.email_outlined),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //             ),
    //           ),
    //         ),
    //
    //         // Password
    //         const SizedBox(height: 10),
    //         Obx(
    //           () => TextFormField(
    //             controller: _controllerPassword,
    //             keyboardType: TextInputType.visiblePassword,
    //             decoration: InputDecoration(
    //               errorText: GetXClass.isValidPassword.value
    //                   ? null
    //                   : "Please enter the password",
    //               labelText: "Password",
    //               prefixIcon: const Icon(Icons.password_outlined),
    //               suffixIcon: IconButton(
    //                 onPressed: () {},
    //                 icon: const Icon(Icons.visibility_outlined),
    //               ),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //             ),
    //           ),
    //         ),
    //
    //         // Confirm Password
    //         const SizedBox(height: 10),
    //         Obx(
    //           () => TextFormField(
    //             controller: _controllerConFirmPassword,
    //             keyboardType: TextInputType.visiblePassword,
    //             decoration: InputDecoration(
    //               labelText: "Confirm Password",
    //               errorText: GetXClass.isValidRePassword.value
    //                   ? null
    //                   : "Password doesn't match",
    //               prefixIcon: const Icon(Icons.password_outlined),
    //               suffixIcon: IconButton(
    //                   onPressed: () {},
    //                   icon: const Icon(Icons.visibility_outlined)),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //             ),
    //           ),
    //         ),
    //
    //         // Image Picker
    //         const SizedBox(height: 50),
    //         Stack(
    //           alignment: Alignment.bottomLeft,
    //           children: [
    //             Obx(
    //               () => Container(
    //                 width: 120,
    //                 height: 120,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.shade400,
    //                   shape: BoxShape.circle,
    //                   image: _imagepath.value.isEmpty
    //                       ? DecorationImage(
    //                           fit: BoxFit.cover,
    //                           image: AssetImage('images/default_image.jpg'),
    //                         )
    //                       : DecorationImage(
    //                           fit: BoxFit.cover,
    //                           image: FileImage(
    //                             File("${_imagepath.value}"),
    //                           ),
    //                         ),
    //                 ),
    //               ),
    //             ),
    //             Positioned(
    //               right: 5,
    //               bottom: 0,
    //               child: IconButton(
    //                 onPressed: () async {
    //                   final ImagePicker picker = ImagePicker();
    //                   final XFile? image =
    //                       await picker.pickImage(source: ImageSource.gallery);
    //                   _imagepath.value = image!.path;
    //                 },
    //                 icon: const Icon(
    //                   Icons.add_a_photo,
    //                   size: 30,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         // Register Button
    //         const SizedBox(height: 50),
    //         ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             minimumSize: const Size.fromHeight(50),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(20),
    //             ),
    //           ),
    //           onPressed: () async {
    //             }
    //           },
    //           child: const Text("Register Now"),
    //         ),
    //
    //         // Login Button
    //         const SizedBox(height: 50),
    //         Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 const Text("Already have an account?"),
    //                 TextButton(
    //                   onPressed: () {
    //                     GetXClass.isValidUsername.value = true;
    //                     GetXClass.isValidEmial.value = true;
    //                     GetXClass.isValidPassword.value = true;
    //                     GetXClass.isValidRePassword.value = true;
    //                     GetXClass.isValidDOB.value = true;
    //                     Get.off(LoginPage());
    //                   },
    //                   child: const Text("Login"),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
