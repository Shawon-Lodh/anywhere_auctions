import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageDetials extends StatefulWidget {
  @override
  _HomePageDetialsState createState() => _HomePageDetialsState();
}

class _HomePageDetialsState extends State<HomePageDetials> {
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
            _getTestAuctionDetails(false),
            _getTestAuctionDetails(true),
          ],
        ),
      ),
    );
  }

  Widget _getAllAuctionDetails(){
    return Container(
      child: GridView.count(
        childAspectRatio: 0.9,
        crossAxisCount: 2,
        children: List<Widget>.generate(16, (index) {
          return GridTile(
            child: Card(
              elevation: 5,
              // color: Colors.blue.shade200,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network("https://c.files.bbci.co.uk/12A9B/production/_111434467_gettyimages-1143489763.jpg"),

                    Text(
                      "Product Name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.red),
                          child: Row(
                            children: [
                              Text(
                                "Bids : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "23",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.yellow),
                          child: Row(
                            children: [
                              Text(
                                "1day 10h 5m",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/timer.gif",
                                height: 20.0,
                                width: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\u09f3 250.00",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
              ),
            ),
          );
        }),
      ),
    );
  }
  Widget _getMyAuctionDetails(){
    return Container(
      child: GridView.count(
        childAspectRatio: 0.88,
        crossAxisCount: 2,
        children: List<Widget>.generate(16, (index) {
          return GridTile(
            child: Card(
              elevation: 5,
              // color: Colors.blue.shade200,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network("https://c.files.bbci.co.uk/12A9B/production/_111434467_gettyimages-1143489763.jpg"),

                    Text(
                      "Product Name",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.red),
                          child: Row(
                            children: [
                              Text(
                                "Bids : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "23",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.yellow),
                          child: Row(
                            children: [
                              Text(
                                "1day 10h 5m",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/timer.gif",
                                height: 20.0,
                                width: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "BDT",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            Text(
                              "250.00",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ],
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
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getTestAuctionDetails(bool myPost){
    return StreamBuilder<QuerySnapshot>(
      stream: myPost ? FirebaseFirestore.instance.collection('products').where("products_created_by", isEqualTo : Constant.userEmail).snapshots() : FirebaseFirestore.instance.collection('products').where("products_created_by", isNotEqualTo : Constant.userEmail).snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          return _makingGridView(snapshot);
        },
    );
  }

  Widget _makingGridView(AsyncSnapshot<QuerySnapshot> querySnapshot){
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
          return GridTile(
            child: Card(
              elevation: 5,
              // color: Colors.blue.shade200,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(singleProductDoc["products_imageUrl"],fit: BoxFit.cover,width: 100,height: 50,),
                    Text(
                      singleProductDoc["products_name"],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.red),
                          child: Row(
                            children: [
                              Text(
                                "Bids : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "23",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.yellow),
                          child: Row(
                            children: [
                              Text(
                                "1day 10h 5m",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/timer.gif",
                                height: 20.0,
                                width: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\u09f3 ${singleProductDoc["products_auction_price"]}",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
              ),
            ),
          );
        }
    );
  }

}
