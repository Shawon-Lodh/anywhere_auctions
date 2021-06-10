import 'dart:async';
import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'home.dart';

class BidCreationDialog extends StatefulWidget {
  final int productId;
  final int productPrice;
  BidCreationDialog({this.productId,this.productPrice});
  @override
  _BidCreationDialogState createState() => _BidCreationDialogState();
}

class _BidCreationDialogState extends State<BidCreationDialog> {

  TextEditingController _bidAmountController = new TextEditingController();
  bool alertShow = false;

  void _saveBidsData(var bidsData) async{
    FirebaseFirestore.instance.collection("bids").add(bidsData);
    //update new price in products
    QuerySnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').where("products_id", isEqualTo : widget.productId).get();
    String productMainID = productSnapshot.docs[0].id;
    await FirebaseFirestore.instance.collection('products').doc(productMainID).update({
      "products_auction_price": bidsData["bid_price"]
    });
  }

  Future<int> getTotalBidsCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('bids').get();
    return querySnapshot.docs.length;
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
                  Align(alignment:Alignment.center,child: Text("Minimum Bid Amount - \u09f3 ${widget.productPrice}",style: TextStyle(fontSize: 3.82*ResponsiveSize.blockSizeHorizontal,fontWeight: FontWeight.w500),)),
                  SizedBox(
                    height: 2.6*ResponsiveSize.blockSizeHorizontal,
                  ),
                  Align(alignment:Alignment.center,child: Text("1 Bid - 1Day 1hour Left",style: TextStyle(color: button_background),)),
                  SizedBox(
                    height: 5.1*ResponsiveSize.blockSizeHorizontal,
                  ),
                  Text("Your Bid Amount"),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 17.83*ResponsiveSize.blockSizeHorizontal),
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _bidAmountController,
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
                              hintText: "bid amount",
                              fillColor: Colors.white70),

                        ),
                      ),
                    ),
                  ),
                  alertShow ? SizedBox(height: 2.6*ResponsiveSize.blockSizeHorizontal) : Container(),
                  alertShow ? Text("Bid amount less than Minimum Bid amount",style: TextStyle(color: Colors.red)): Container(),
                  SizedBox(
                    height: 5.1*ResponsiveSize.blockSizeHorizontal,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async{
                        if(_bidAmountController.text == ""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill up the product Bid amount")));
                        }else if(int.parse(_bidAmountController.text) < widget.productPrice){
                          setState(() {
                            alertShow = true;
                          });
                          Timer timer = Timer(Duration(seconds: 3), () {
                            setState(() {
                              alertShow = false;
                            });
                          });
                        }else{
                          EasyLoading.show(status: 'loading...');
                          int bidCount = await getTotalBidsCount();
                          setState(() {
                            Map <String, dynamic> bidsData = {
                              "bid_id" : bidCount+1,
                              "product_id": widget.productId,  //productsData["name"],
                              "user_name": Constant.userName,  // productsData["des"],
                              "user_email": Constant.userEmail,
                              "bid_price": int.parse(_bidAmountController.text),  // productsData["price"],
                            };

                            _saveBidsData(bidsData);

                            _bidAmountController.text = "";

                            EasyLoading.showSuccess('Bid Creation is Successful');
                            // EasyLoading.dismiss();
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                                  (Route<dynamic> route) => false,
                            );
                          });
                        }

                      },
                      child: Container(
                        padding: EdgeInsets.all(3.82*ResponsiveSize.blockSizeHorizontal),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.82*ResponsiveSize.blockSizeHorizontal)),
                          color: button_background,
                        ),
                        child: Text(
                          "Place Bid",
                          style: TextStyle(
                            fontSize: 5.1*ResponsiveSize.blockSizeHorizontal,
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

