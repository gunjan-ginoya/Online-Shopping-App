import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_shopping_app/pages/Homepage.dart';

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

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Sell Product",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Name",
                style: TextStyle(fontSize: 17),
              ),
              TextFormField(
                controller: _controllerName,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Description",
                style: TextStyle(fontSize: 17),
              ),
              TextFormField(
                controller: _controllerDesc,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Price",
                style: TextStyle(fontSize: 17),
              ),
              TextFormField(
                controller: _controllerPrice,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Column(
              //       children: [
              //         GestureDetector(
              //           onTap: () async {
              //             final ImagePicker picker = ImagePicker();
              //             final XFile? image =
              //             await picker.pickImage(source: ImageSource.gallery);
              //             _imagepath.value = image!.path;
              //           },
              //           child: Container(
              //             height: 200,
              //             width: 200,
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               border: Border.all(
              //                 color: Colors.black,
              //               ),
              //             ),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Icon(
              //                   Icons.add_a_photo_outlined,
              //                   color: Colors.black,
              //                   size: 30,
              //                 ),
              //                 Text("Add Photo", style: TextStyle(fontSize: 20),)
              //               ],
              //             ),
              //           ),
              //         )
              //       ],
              //     )
              //   ],
              // ),
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
                  _imagepath.value = image!.path;

                  // CroppedFile? croppedFile = await ImageCropper().cropImage(
                  //   sourcePath: _imagepath.value,
                  //   aspectRatioPresets: [
                  //     CropAspectRatioPreset.square,
                  //     CropAspectRatioPreset.ratio3x2,
                  //     CropAspectRatioPreset.original,
                  //     CropAspectRatioPreset.ratio4x3,
                  //     CropAspectRatioPreset.ratio16x9
                  //   ],
                  //   uiSettings: [
                  //     AndroidUiSettings(
                  //         toolbarTitle: 'Cropper',
                  //         toolbarColor: Colors.deepOrange,
                  //         toolbarWidgetColor: Colors.white,
                  //         initAspectRatio: CropAspectRatioPreset.original,
                  //         lockAspectRatio: false),
                  //     IOSUiSettings(
                  //       title: 'Cropper',
                  //     ),
                  //     WebUiSettings(
                  //       context: context,
                  //     ),
                  //   ],
                  // ).then((value) async {
                  //   if (value != null) {
                  //     _imagepath.value = value.path;
                  //   }
                  //   return null;
                  // });
                },
                child: Obx(
                      () => Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ), 
                      ),
                      child: _imagepath.value.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.add_a_photo)],
                      )
                          : Image(
                        image: FileImage(File(_imagepath.value)),
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_imagepath.value.isNotEmpty) {
                        _image = base64Encode((await File(_imagepath.value)
                            .readAsBytes()) as List<int>);
                        _imagename = "img${DateTime.now().second}";
                      }

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
                    },
                    child: Text('ADD'),
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
