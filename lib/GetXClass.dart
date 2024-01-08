import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetXClass extends GetxController {
  static SharedPreferences? prefs;

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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkConnection();
  }

  Future<void> checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      Get.defaultDialog(title: "Check your internet connection");
    }
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        Get.defaultDialog(title: "Check your internet connection");
      }
    });
  }
}
