import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:online_shopping_app/pages/cart/cart_page.dart';
import 'package:online_shopping_app/pages/product_details/product_details.dart';
import 'package:online_shopping_app/widgets/product_Card.dart';
import '../constants.dart';
import '../model/product.dart';
import '../widgets/icon_button.dart';
import 'add_product/add_product.dart';
import 'package:http/http.dart' as http;

class BuyProducts extends StatelessWidget {
  const BuyProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      child: Text(
                    "Buy or Sell",
                    style: TextStyle(fontSize: 15),
                  )),
                  const SizedBox(width: 16),
                  // IconBtn(
                  //   svgSrc: "assets/icons/Cart Icon.svg",
                  //   press: () => Get.to(CartPage()),
                  // ),
                  const SizedBox(width: 8),
                  IconBtn(
                    svgSrc: "assets/icons/Plus.svg",
                    press: () => Get.to(AddProduct()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getdata(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Please Check Your Network'),
                    );
                  } else {
                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      itemCount: snapshot.data!['product_data'].length,
                      itemBuilder: (BuildContext context, int index) {
                        Map map = snapshot.data!['product_data'][index];
                        Product product = Product(
                            id: map['product_id'],
                            name: map['product_name'],
                            price: map['product_price'],
                            decription: map['product_desc'],
                            image: map['product_image']);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductCard(
                            product: product,
                            onPress: () {
                              Get.to(
                                product_details(
                                    name: product.name,
                                    price: product.price,
                                    des: product.decription,
                                    image: product.image),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map> getdata() async {
    var url = Uri.parse(
        'https://gunjanecommapp.000webhostapp.com/select_product.php');
    var response = await http.post(url);
    var view_product = jsonDecode(response.body);
    return view_product;
  }
}
