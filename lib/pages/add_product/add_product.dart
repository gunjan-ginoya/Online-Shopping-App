import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_shopping_app/pages/Homepage.dart';
import 'package:online_shopping_app/pages/add_product/component/custome_textdeild.dart';

import '../../constants.dart';
import '../../widgets/custome_sufix_icon.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerName = TextEditingController();
    TextEditingController _controllerPrice = TextEditingController();
    TextEditingController _controllerDesc = TextEditingController();
    RxString _imagepath = "".obs;
    String _image = "";
    String _imagename = "";
    RxBool isLoading = false.obs;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.offAll(const Homepage());
                        },
                        child: const CustomSurffixIcon(
                            svgIcon: "assets/icons/Back ICon.svg")),
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Text(
                        "Add Product To Sell",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              //name
              const SizedBox(height: 30),
              CustomeTextfeild(
                controller: _controllerName,
                title: "Name",
                hintText: "Enter product name",
                keyboardType: TextInputType.name,
                error: Container(),
              ),
              const SizedBox(height: 30),

              // Description
              CustomeTextfeild(
                controller: _controllerDesc,
                title: "About product",
                hintText: "Condition, age, etc.",
                keyboardType: TextInputType.name,
                error: Container(),
              ),
              const SizedBox(height: 30),

              // Price
              CustomeTextfeild(
                controller: _controllerPrice,
                title: "Price",
                hintText: "Enter product price",
                error: Container(),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Product image
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  _imagepath.value = image!.path;
                },
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Product Image"),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          image: _imagepath.value.isNotEmpty
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(
                                      _imagepath.value,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        child: _imagepath.value.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.add_a_photo)],
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),

              // Add Product
              Obx(
                () => Container(
                  margin: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    onPressed: () async {
                      isLoading.value = true;
                      if (_imagepath.value.isNotEmpty) {
                        _image = base64Encode((await File(_imagepath.value)
                            .readAsBytes()) as List<int>);
                        _imagename = "img${DateTime.now().second}";
                      }

                      if (_controllerName.text.isNotEmpty &&
                          _controllerPrice.text.isNotEmpty &&
                          _controllerDesc.text.isNotEmpty) {
                        Map body = {
                          'product_name': _controllerName.text.trim(),
                          'product_desc': _controllerDesc.text.trim(),
                          'product_price': _controllerPrice.text.trim(),
                          'product_image': _image,
                          'imageName': _imagename
                        };
                        var url = Uri.parse(
                            'https://gunjanecommapp.000webhostapp.com/add_product.php');
                        var response = await http.post(url, body: body);
                        // print('xyzzzzzzz: ${response.body}');

                        Get.offAll(Homepage());
                      }
                      isLoading.value = false;
                    },
                    child: isLoading.value
                        ? Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text("Add Product"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
