import 'package:anywhere_auction/Views/dashboard.dart';
import 'package:anywhere_auction/Views/home_body.dart';
import 'package:anywhere_auction/Views/signIn_page.dart';
import 'package:anywhere_auction/constants/colors.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_auction_product_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  
  @override
  void initState(){
    currentIndex = 0;
    super.initState();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  var screens = [
    HomePageDetials(),
    Dashboard(),
  ]; //screens for each tab

  @override
  Widget build(BuildContext context) {
    ResponsiveSize().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: button_background,
            title: Center(child: Text("Anywhere Auction"),),
            actions: <Widget>[
              CircleAvatar(
                radius: 5.1*ResponsiveSize.blockSizeHorizontal,
                backgroundImage:
                NetworkImage(Constant.userPhotoUrl),
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
                        SizedBox(
                          width: 1.8*ResponsiveSize.blockSizeHorizontal,
                        ),
                        Text("Logout")
                      ],
                    ),
                  ),
                ],
                onSelected: (item){
                  if(item == 0){
                    _googleSignIn.signOut().then((value) {
                      setState(() async{
                        SharedPreferences pref = await SharedPreferences.getInstance();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return ProductCreationDialog();
                });
          },
          child: Icon(Icons.add),
          backgroundColor: button_background,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0.2,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.black12,
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          onTap: changePage,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: button_background,
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.home,
                color: button_background,
              ),
              title: Text("Home"),
            ),
            BubbleBottomBarItem(
              backgroundColor: button_background,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: button_background,
              ),
              title: Text("Dashboard"),
            ),
          ],
        ),
        body: screens[currentIndex],
      ),
    );
  }
}


