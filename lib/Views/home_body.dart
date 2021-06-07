import 'dart:async';

import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auction_product_details.dart';

class HomePageDetials extends StatefulWidget {
  @override
  _HomePageDetialsState createState() => _HomePageDetialsState();
}

class _HomePageDetialsState extends State<HomePageDetials> {
  Timer timer;
  String remainingTime = "";


  checkForRemainingAuctionEndTime(DateTime auctionEndTime){
    int day =0;
    int hour = 0;
    int minute = 0;
    // DateTime endDate = DateTime.parse(singleProductDoc["products_auction_TotalTime"].toDate().toString());
    final difference = auctionEndTime.difference(DateTime.now()).inMinutes;
    // print(endDate);
    print(difference);
    if(difference/(60*24) == 0){
      day = difference~/(60*24);
      hour = 0;
      minute = 0;
    }else if((difference%(60*24))/60 == 0){
      day = difference~/(60*24);
      hour = (difference%(60*24))~/60;
    }else{
      day = difference~/(60*24);
      hour = (difference%(60*24))~/60;
      minute = (difference%(60*24))%60;
    }
    // print("${day} day - ${hour} hour - ${minute} minute");
    // Map <String, dynamic> remainingTime = {
    //   "day" : day,
    //   "hour" : hour,
    //   "minute" : minute,
    // };
    remainingTime = "${day}day ${hour}h ${minute}m";
    // return remainingTime;
  }

  Future<int> getTotalBidsCountBasedOnProduct(int productId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bids')
        .where("product_id", isEqualTo: productId)
        .get();
    print(querySnapshot.docs.length);
    return querySnapshot.docs.length;
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: button_background,
          title: TabBar(
            indicatorWeight: 10.0,
            tabs: <Widget>[
              Tab(
                text: 'All posts',
              ),
              Tab(
                text: 'My posts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _getAuctionDetails(false),
            _getAuctionDetails(true),
          ],
        ),
      ),
    );
  }


  Widget _getAuctionDetails(bool myPost) {
    return StreamBuilder<QuerySnapshot>(
      stream: myPost
          ? FirebaseFirestore.instance
          .collection('products')
          .where("products_created_by", isEqualTo: Constant.userEmail)
          .snapshots()
          : FirebaseFirestore.instance
          .collection('products')
          .where("products_created_by", isNotEqualTo: Constant.userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return _makingGridView(snapshot,myPost);
      },
    );
  }

  Widget _makingGridView(AsyncSnapshot<QuerySnapshot> querySnapshot, bool myPost) {
    return GridView.builder(
      // physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: querySnapshot.data.docs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.9,
          crossAxisCount: 2,
          // crossAxisSpacing: 10.0,
          // mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          final singleProductDoc = querySnapshot.data.docs[index];
          checkForRemainingAuctionEndTime(DateTime.parse(singleProductDoc["products_auction_TotalTime"].toDate().toString()));
          timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
            setState(() {
              checkForRemainingAuctionEndTime(DateTime.parse(singleProductDoc["products_auction_TotalTime"].toDate().toString()));
            });
          });
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuctionProductDetails(
                      singleProductSnapshot: singleProductDoc,myPost: myPost,),
                  ));
            },
            child: GridTile(
              child: Card(
                elevation: 5,
                // color: Colors.blue.shade200,
                child: FutureBuilder(
                    future: getTotalBidsCountBasedOnProduct(singleProductDoc["products_id"]),
                    initialData: 0,
                    builder: (BuildContext context,
                        AsyncSnapshot<int> totalBidCount) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              singleProductDoc["products_imageUrl"],
                              fit: BoxFit.cover,
                              width: 100,
                              height: 50,
                            ),
                            Text(
                              singleProductDoc["products_name"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Bids : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,color: Colors.white),
                                      ),
                                      Text(
                                        "${totalBidCount.data}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration:
                                      BoxDecoration(color: Colors.yellow),
                                      child: Row(
                                        children: [
                                          Text(
                                            remainingTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/images/timer.gif",
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "\u09f3 ${singleProductDoc["products_auction_price"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                Image.asset(
                                  "assets/images/front_page_logo.png",
                                  height: 25.0,
                                  width: 25.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }
}