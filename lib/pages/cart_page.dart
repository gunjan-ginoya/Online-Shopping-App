import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping_app/GetXClass.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "MY CART",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
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
                  print('!!!!!!!!!!!!! ${cartdata}');
                  return ListView.builder(
                    itemCount: cartdata.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              setState(() {
                                DeleteFromCart(
                                    cartId: cartdata[index]["cart_id"]);
                              });
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  setState(() {
                                    DeleteFromCart(
                                        cartId: cartdata[index]["cart_id"]);
                                  });
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(cartdata[index]["product_name"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "\u{20B9}${cartdata[index]["product_price"]}",
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(cartdata[index]
                                                ["product_image"]),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
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
