import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping_app/GetXClass.dart';
import 'package:online_shopping_app/constants.dart';
import 'package:online_shopping_app/pages/Homepage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'components/product_image.dart';
import 'components/top_rounded_container.dart';

class product_details extends StatelessWidget {
  product_details({
    super.key,
    required this.name,
    required this.price,
    required this.des,
    required this.image,
  });

  String name;
  String price;
  String des;
  String image;
  RxBool isloading = false.obs;
  late Razorpay razorpay;

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery
        .of(context)
        .size
        .height - 465;
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    // int uid1=int.parse(uid);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Get.offAll(const Homepage()),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ProductImages(
            productImage: image,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            height: containerHeight,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "\$ $price",
                        style:
                        const TextStyle(fontSize: 15, color: kPrimaryColor),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 64,
                  ),
                  child: Text(
                    des,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () async {
                isloading.value = true;
                // TODO: Implement Payment Gateway
                String userEmail = await getUserData();
                double finalPrice = double.parse(price) * 100;
                checkOut(finalPrice, name, des, userEmail);
              },
              child: isloading.value
                  ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
                  : const Text("Buy Now"),
            ),
          ),
        ),
      ),
    );
  }

  void checkOut(double price, String name, String description,
      String email) async {
    var options = {
      'key': 'rzp_test_1YACqVrlNL0WZY',
      'amount': price,
      'name': '$name',
      'description': '$description',
      'prefill': {'contact': '9313861061', 'email': '$email'}
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print('Error during payment: $e');
    }
  }

  Future<String> getUserData() async {
    var url =
    Uri.parse("https://gunjanecommapp.000webhostapp.com/get_user_data.php");
    var response = await http
        .post(url, body: {"user_id": GetXClass.prefs!.getString("userid")});
    var userData = jsonDecode(response.body);
    return userData["userData"][0]["email"];
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    String id = response.paymentId!;
    addToCart(id).then((value) => Get.offAll(Homepage()));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  Future<void> addToCart(String paymentId) async {
    var url =
    Uri.parse("https://gunjanecommapp.000webhostapp.com/add_to_cart.php");
    Map body = {
      "user_id": GetXClass.prefs!.getString("userid"),
      "product_name": name.trim(),
      "product_desc": des.trim(),
      "product_price": price.trim(),
      "product_image": image.trim(),
      "transaction_id": paymentId,
    };
    var respoance = await http.post(url, body: body);
    print("###@ ${respoance.body}");
  }
}
