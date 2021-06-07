import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getTotalRunningBids(),
          initialData: 0,
          builder:
              (BuildContext context, AsyncSnapshot<int> totalRunningBidCount) {
            return Container(
              child: Center(
                  child: Text(
                "Total Running Bid : ${totalRunningBidCount.data}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
            );
          }),
    );
  }
}
