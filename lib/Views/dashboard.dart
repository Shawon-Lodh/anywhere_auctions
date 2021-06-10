import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<int> getTotalRunningBids() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where("products_auction_completedStatus", isEqualTo: false)
        .get();
    return querySnapshot.docs.length;
  }
  Future<int> getTotalCompletedBids() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where("products_auction_completedStatus", isEqualTo: true)
        .get();
    return querySnapshot.docs.length;
  }
  Future<int> getValueOfCompletedBids() async {
    int totalValue = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where("products_auction_completedStatus", isEqualTo: true)
        .get();

    for(int i = 0;i<querySnapshot.docs.length;i++){
      totalValue = totalValue + querySnapshot.docs[i]["products_auction_price"];
    }
    return totalValue;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize().init(context);
    return Scaffold(
      body: FutureBuilder<List>(
          future: Future.wait([getTotalRunningBids(),getTotalCompletedBids(),getValueOfCompletedBids()]),
          initialData: [0,0,0],
          builder:
              (BuildContext context, AsyncSnapshot<List> totalRunningAndCompletedBidCountWithCompletedBidsValue) {
                return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                      margin: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                      decoration: BoxDecoration(
                        border: Border.all(color: button_background,width: 0.77*ResponsiveSize.blockSizeHorizontal),
                        borderRadius: BorderRadius.all(Radius.circular(1.28*ResponsiveSize.blockSizeHorizontal)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Running Bid",
                                style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                            margin: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                            decoration: BoxDecoration(
                              border: Border.all(color: button_background,width: 0.77*ResponsiveSize.blockSizeHorizontal),
                              borderRadius: BorderRadius.all(Radius.circular(1.28*ResponsiveSize.blockSizeHorizontal)),
                            ),
                            child: Text(
                              "${totalRunningAndCompletedBidCountWithCompletedBidsValue.data[0]}",
                              style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                      margin: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                      decoration: BoxDecoration(
                        border: Border.all(color: button_background,width: 0.77*ResponsiveSize.blockSizeHorizontal),
                        borderRadius: BorderRadius.all(Radius.circular(1.28*ResponsiveSize.blockSizeHorizontal)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Completed Bid",
                                style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                            margin: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                            decoration: BoxDecoration(
                              border: Border.all(color: button_background,width: 0.77*ResponsiveSize.blockSizeHorizontal),
                              borderRadius: BorderRadius.all(Radius.circular(1.28*ResponsiveSize.blockSizeHorizontal)),
                            ),
                            child: Text(
                              "${totalRunningAndCompletedBidCountWithCompletedBidsValue.data[1]}",
                              style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(7.7*ResponsiveSize.blockSizeHorizontal),
                  margin: EdgeInsets.all(5.1*ResponsiveSize.blockSizeHorizontal),
                  decoration: BoxDecoration(
                    border: Border.all(color: button_background,width: 0.77*ResponsiveSize.blockSizeHorizontal),
                    borderRadius: BorderRadius.all(Radius.circular(1.28*ResponsiveSize.blockSizeHorizontal)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Value of Completed Bids ",
                        style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                        margin: EdgeInsets.all(2.6*ResponsiveSize.blockSizeHorizontal),
                        decoration: BoxDecoration(
                          border: Border.all(color: button_background,width: 0.77*ResponsiveSize.blockSizeHorizontal),
                          borderRadius: BorderRadius.all(Radius.circular(1.28*ResponsiveSize.blockSizeHorizontal)),
                        ),
                        child: Text(
                          "\u09F3 ${totalRunningAndCompletedBidCountWithCompletedBidsValue.data[2]}",
                          style: TextStyle(fontSize: 5.1*ResponsiveSize.blockSizeHorizontal, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
