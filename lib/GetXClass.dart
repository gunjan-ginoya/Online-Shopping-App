import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetXClass extends GetxController {
  static SharedPreferences? prefs;
  static RegExp emailRegexp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");

  // register page
  static RxString gender = "Male".obs;
  static RxBool cricket = false.obs;
  static RxBool music = false.obs;

  static RxBool isValidUsername = true.obs;
  static RxBool isValidEmial = true.obs;
  static RxBool isValidPassword = true.obs;
  static RxBool isValidRePassword = true.obs;
  static RxBool isValidDOB = true.obs;
  static RxBool isValidGender = true.obs;

  // Login page
  static RxBool isValidEmailLogin = true.obs;

  static RxBool isValidPasswordLogin = true.obs;

  static Future<void> getSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  static RxList allContacts = [].obs;
}