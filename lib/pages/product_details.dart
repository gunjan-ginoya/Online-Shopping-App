import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping_app/GetXClass.dart';
import 'package:online_shopping_app/pages/cart_page.dart';

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

  @override
  Widget build(BuildContext context) {
    String? uid = GetXClass.prefs?.getString('userid') ?? "";
    // int uid1=int.parse(uid);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.fill)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      child: Text("\u{20B9}${price}",
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(des,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                      shape: BoxShape.rectangle,
                      gradient: const LinearGradient(
                          colors: [Colors.red, Colors.blue],
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    alignment: Alignment.center,
                    child: Text("BUY NOW",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      print(uid);
                      // print("===$uid1");
                      Map map = {
                        "product_name": name,
                        "product_desc": des,
                        "product_price": price,
                        "user_id": uid,
                        "product_image": image,
                        "quantity ": '1'
                      };
                      isloading.value = true;
                      var url = Uri.parse(
                          'https://gunjanecommapp.000webhostapp.com/add_to_cart.php');
                      var response = await http.post(url, body: map);
                      print("!!ADD TO CART!! ${response.body}");
                      isloading.value = false;

                      Get.to(CartPage());
                    },
                    child: Obx(
                          () => Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black),
                          shape: BoxShape.rectangle,
                          gradient: const LinearGradient(
                              colors: [Color(0xff2d388a), Color(0xff00aeef)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        alignment: Alignment.center,
                        child: isloading.value
                            ? CircularProgressIndicator()
                            : Text("ADD TO CART",
                            style: TextStyle(
                                fontSize: 20, color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}