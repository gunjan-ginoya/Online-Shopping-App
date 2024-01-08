import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping_app/GetXClass.dart';
import 'package:online_shopping_app/pages/cart/componenets/cart_Card.dart';

import '../../constants.dart';
import '../../widgets/icon_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Expanded(
                child: Row(
                  children: [
                    Text(
                      "Your Orders",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: cartgetdata(),
                builder: (context, snapshot) {
                  // print('!!!!!!!!!!!!! ${snapshot.connectionState}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error ${snapshot.error}'),
                    );
                  } else {
                    final cartdata = snapshot.data!['cartData'];
                    return cartdata == []
                        ? const Center(
                            child: Text(
                              "Cart Is Empty",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cartdata.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CartCard(
                                  image: cartdata[index]["product_image"],
                                  name: cartdata[index]["product_name"],
                                  price: cartdata[index]["product_price"],
                                  id: cartdata[index]["transaction_id"],
                                ),
                              );
                            },
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }

  Future<Map> cartgetdata() async {
    print("!!userid!! ${GetXClass.prefs?.getString('userid')}");
    var url = Uri.parse(
        'https://gunjanecommapp.000webhostapp.com/select_cart_data.php');
    var response = await http
        .post(url, body: {'user_id': GetXClass.prefs?.getString('userid')});
    print("!!RESPOANCE!! ${response.body}");
    var view_Cartdata = jsonDecode(response.body);
    return view_Cartdata;
  }

  Future<void> DeleteFromCart({required String cartId}) async {
    var url = Uri.parse(
        "https://gunjanecommapp.000webhostapp.com/delete_from_cart.php");
    var response = await http.post(url, body: {'cart_id': cartId});
  }
}
