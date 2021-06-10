import 'dart:io';
import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class ProductCreationDialog extends StatefulWidget {
  @override
  _ProductCreationDialogState createState() => _ProductCreationDialogState();
}

class _ProductCreationDialogState extends State<ProductCreationDialog> {
  File _image;

  DateTime _date;

  TimeOfDay _time;

  TextEditingController _productNameController = new TextEditingController();
  TextEditingController _productDesController = new TextEditingController();
  TextEditingController _productBidPriceController = new TextEditingController();



  Future getImageFromCamera() async{
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async{
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }


  Future<int> getTotalProductsCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();

    return querySnapshot.docs.length;
  }

  void _saveProductssData(var productsData) {
    FirebaseFirestore.instance.collection("products").add(productsData);
  }

  Future<String> uploadImage() async{
    String fileName = basename(_image.path);
    var fireBaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    var uploadTask = fireBaseStorageRef.putFile(_image);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    final url = imageUrl.toString();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize().init(context);
    return Container(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.1*ResponsiveSize.blockSizeHorizontal),
        ),
        child: SingleChildScrollView(
          child: Container(
            // height: 200,
            child: Padding(
              padding: EdgeInsets.all(3.06*ResponsiveSize.blockSizeHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(alignment: Alignment.topRight,
                    child: IconButton(icon: Icon(Icons.cancel),
                      onPressed: (){
                        Navigator.pop(context);
                      },),
                  ),
                  Text("Product Name"),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 17.83*ResponsiveSize.blockSizeHorizontal),
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _productNameController,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.6*ResponsiveSize.blockSizeHorizontal),
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              hintText: "products name",
                              fillColor: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  Text("Product Description(optional)"),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 25.47*ResponsiveSize.blockSizeHorizontal),
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _productDesController,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.6*ResponsiveSize.blockSizeHorizontal),
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              hintText: "product description",
                              fillColor: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Product Photo"),
                      SizedBox(width: 2.6*ResponsiveSize.blockSizeHorizontal,),
                      _image != null ? Image.file(_image,width: 12.74*ResponsiveSize.blockSizeHorizontal,height: 12.74*ResponsiveSize.blockSizeHorizontal,) : GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: getImageFromCamera,),
                            SizedBox(width: 2.6*ResponsiveSize.blockSizeHorizontal,),
                            IconButton(
                              icon: Icon(Icons.insert_photo),
                              onPressed: getImageFromGallery,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text("Minimum Bid Price"),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 17.83*ResponsiveSize.blockSizeHorizontal),
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _productBidPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ], // Only numbers can be entered
                          maxLines: null,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.6*ResponsiveSize.blockSizeHorizontal),
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              hintText: "product minimum bid price",
                              fillColor: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Aunction End Date"),
                      SizedBox(width: 2.6*ResponsiveSize.blockSizeHorizontal,),
                      IconButton(onPressed: (){
                        FocusScope.of(context).unfocus();
                        showDatePicker(
                            context: context,
                            initialDate: _date == null? DateTime.now() : _date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101)).then((date){
                          setState(() {
                            _date = date;
                          });
                        });
                      },
                        icon: Icon(Icons.calendar_today_sharp),),
                      SizedBox(width: 2.6*ResponsiveSize.blockSizeHorizontal,),
                      Text(_date == null? "" : "${DateFormat("dd-MM-yyyy").format(_date)}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Aunction End Time"),
                      SizedBox(width: 2.6*ResponsiveSize.blockSizeHorizontal,),
                      IconButton(onPressed: (){
                        FocusScope.of(context).unfocus();
                        showTimePicker(
                            context: context,
                            initialTime: _time == null? TimeOfDay.now() : _time).then((time){
                          setState(() {
                            _time = time;
                          });
                        });
                      },
                        icon: Icon(Icons.timer),),
                      SizedBox(width: 2.6*ResponsiveSize.blockSizeHorizontal,),
                      Text(_time == null? "" : "${_time.hour}:${_time.minute}"),
                    ],
                  ),
                  SizedBox(
                    height: 5.1*ResponsiveSize.blockSizeHorizontal,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async{
                        if(_productNameController.text == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill up the product Name")));
                        }else if(_image == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Image is not selected")));
                        }else if(_productBidPriceController.text == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill up the product Minimum Bid price")));
                        }else if(_date == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select the auction End Date")));
                        }else if(_time == null){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select the auction End Time")));
                        }else{
                          EasyLoading.show(status: 'loading...');
                          final url = await uploadImage();
                          int productsCount = await getTotalProductsCount();
                          setState(() {

                            Map <String, dynamic> productsData = {
                              "products_id" : productsCount+1,
                              "products_name": _productNameController.text,  //productsData["name"],
                              "products_des": _productDesController.text,  // productsData["des"],
                              "products_imageUrl": url,
                              "products_auction_price": int.parse(_productBidPriceController.text),  // productsData["price"],
                              "products_auction_TotalTime": DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute),
                              "products_auction_completedStatus": false,
                              "products_after_auction_end_bid_creation_status" : false,
                              "products_created_by": Constant.userEmail,
                              "products_auction_winning_user_name": "",
                              "products_auction_winning_user_email": "",
                            };

                            _saveProductssData(productsData);

                            _productNameController.text = "";
                            _productDesController.text = "";
                            _image = null;
                            _productBidPriceController.text = "";
                            _date = null;
                            _time = null;

                            EasyLoading.showSuccess('Auction Product Creation is Successful');
                            // EasyLoading.dismiss();
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.1*ResponsiveSize.blockSizeHorizontal)),
                          color: button_background,
                        ),
                        child: Text(
                          "Create",
                          style: TextStyle(
                            fontSize: 3.82*ResponsiveSize.blockSizeHorizontal,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.1*ResponsiveSize.blockSizeHorizontal,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}