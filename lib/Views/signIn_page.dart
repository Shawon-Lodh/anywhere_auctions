import 'package:anywhere_auction/Views/dashboard.dart';
import 'package:anywhere_auction/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/constants.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    ResponsiveSize().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 1.5 * ResponsiveSize.blockSizeVertical,),
                        Text("Anywhere",style: TextStyle(fontSize: 4 * ResponsiveSize.blockSizeVertical,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(width: 1 * ResponsiveSize.blockSizeHorizontal,),
                    Image.asset('assets/images/front_page_logo.png',width: 8 * ResponsiveSize.blockSizeHorizontal,height: 8*ResponsiveSize.blockSizeVertical,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10 * ResponsiveSize.blockSizeHorizontal,),
                    Text("Auctions",style: TextStyle(fontSize: 2.8 * ResponsiveSize.blockSizeVertical,fontWeight: FontWeight.w500),),
                    SizedBox(width: 0.5 * ResponsiveSize.blockSizeHorizontal,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Be there",style: TextStyle(fontSize: 1 * ResponsiveSize.blockSizeVertical,),),
                        Text("From anywhere",style: TextStyle(fontSize: 1 * ResponsiveSize.blockSizeVertical,),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50*ResponsiveSize.blockSizeVertical,),
            Column(
              children: [
                GestureDetector(
                  onTap: (){

                    _googleSignIn.signIn().then((userData) {
                      setState(() {
                        _isLoggedIn = true;
                        _userObj = userData;
                        print(userData);
                        print(userData.runtimeType);
                        Get.to(Dashboard(),arguments: [userData]);
                      });
                    }).catchError((e) {
                      print(e);
                    });

                  },
                  child: Container(
                    width: 65*ResponsiveSize.blockSizeHorizontal,
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: button_background,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google_icon.png',width: 5 * ResponsiveSize.blockSizeHorizontal,height: 5*ResponsiveSize.blockSizeVertical),
                        SizedBox(width: 1*ResponsiveSize.blockSizeHorizontal,),
                        Text("Sign In with Google",style: TextStyle(fontSize: 2.5 * ResponsiveSize.blockSizeVertical,fontWeight: FontWeight.bold,color: Colors.white,),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1*ResponsiveSize.blockSizeVertical,),
                Text("Login to continue",style: TextStyle(fontSize: 2 * ResponsiveSize.blockSizeVertical,fontWeight: FontWeight.w500),),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
