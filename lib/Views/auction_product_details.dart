import 'package:anywhere_auction/Views/signIn_page.dart';
import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_bid_dialog.dart';


class AuctionProductDetails extends StatefulWidget {
  QueryDocumentSnapshot singleProductSnapshot;

  final bool myPost;

  AuctionProductDetails({this.singleProductSnapshot,this.myPost});

  @override
  _AuctionProductDetailsState createState() => _AuctionProductDetailsState();
}

class _AuctionProductDetailsState extends State<AuctionProductDetails> {
  GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<int> getTotalBidsCountBasedOnProduct() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('bids').where("product_id", isEqualTo : widget.singleProductSnapshot["products_id"]).get();
    print(querySnapshot.docs.length);
    return querySnapshot.docs.length;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    ResponsiveSize().init(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: button_background,
          title: Center(
            child: Text("Anywhere Auction"),
          ),
          actions: <Widget>[
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(Constant.userPhotoUrl),
              backgroundColor: Colors.transparent,
            ),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text("Logout")
                    ],
                  ),
                ),
              ],
              onSelected: (item) {
                if (item == 0) {
                  _googleSignIn.signOut().then((value) {
                    setState(() async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("user_email", "");
                      pref.setString("user_name", "");
                      pref.setString("user_photoUrl", "");
                      pref.setBool("login_status", false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                        (Route<dynamic> route) => false,
                      );
                    });
                  }).catchError((e) {});
                  print("Logout Clicked");
                }
              },
            )
          ]),
      body: FutureBuilder(
          future: getTotalBidsCountBasedOnProduct(),
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> totalBidCount) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: button_background),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Image.network(
                          widget.singleProductSnapshot["products_imageUrl"],
                          width: ResponsiveSize.screenWidth,
                          height: ResponsiveSize.screenHeight/3,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.singleProductSnapshot["products_name"],
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: button_background),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Text(
                                  "\u09f3 ${widget.singleProductSnapshot["products_auction_price"]}",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w800),
                                ),
                              ),
                              Text(
                                "Active",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                      Text(widget.singleProductSnapshot["products_des"]),
                      Row(
                        children: [
                          Text(
                            "All Bidders",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "  - ",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${totalBidCount.data}" ,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: button_background),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 130),
                          child: _getBidderDetails(),
                        ),
                      ),
                      widget.myPost ? Container() : Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return BidCreationDialog(productId: widget.singleProductSnapshot["products_id"],productPrice: widget.singleProductSnapshot["products_auction_price"],);
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: button_background,
                            ),
                            child: Text(
                              "Bid Now",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              );
          }
      ),
    );
  }
  Widget _getBidderDetails(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('bids').where("product_id", isEqualTo : widget.singleProductSnapshot["products_id"]).snapshots(),
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
          childAspectRatio: 5,
          crossAxisCount: 1,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              singleProductDoc["user_name"],
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              singleProductDoc["user_email"],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: button_background),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "\u09f3 ${singleProductDoc["bid_price"]}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                          ),
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
