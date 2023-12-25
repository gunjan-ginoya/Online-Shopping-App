import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../model/product.dart';
import 'add_product.dart';
import 'package:http/http.dart' as http;

class BuyProducts extends StatelessWidget {
  const BuyProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Buy or Sell",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(AddProduct());
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getdata(),
              builder: (context, snapshot) {
                print('!!!!!!!!!!!!! ${snapshot.connectionState}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error'),
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
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(product_details(
                            //     name: product.name,
                            //     price: product.price,
                            //     des: product.decription,
                            //     image: product.image));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(product.image),
                              // Container(
                              //   height: 200,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       border: Border.all(color: Colors.white),
                              //       image: DecorationImage(
                              //         image: NetworkImage(product.image),
                              //         // fit: BoxFit.fill,
                              //       )),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(product.name,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Center(
                                child: Text("\u{20B9}${product.price}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
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
  }

  Future<Map> getdata() async {
    var url = Uri.parse(
        'https://gunjanecommapp.000webhostapp.com/select_product.php');
    var response = await http.post(url);
    print("++++++++++++");
    var view_product = jsonDecode(response.body);
    // ProductData=jsonDecode(response.body);
    print("Show_product=$view_product");
    return view_product;
  }
}
