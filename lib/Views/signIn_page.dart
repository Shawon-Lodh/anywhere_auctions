import 'package:anywhere_auction/Views/home.dart';
import 'package:anywhere_auction/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  bool previousLoggedIn = false;


  setData()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("user_email", _userObj.email);
      pref.setString("user_photoUrl", _userObj.photoUrl);
      pref.setBool("login_status", true);
      Constant.userEmail = pref.getString("user_email")??"";
      Constant.userPhotoUrl = pref.getString("user_photoUrl")??"";
      Constant.loggedIn = pref.getBool("login_status")??false;

      print(Constant.userEmail);
    });

  }


  checkPreviousSignIn(String userEmail) async {

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    //
    // for(int i = 0;i<querySnapshot.docs.length;i++){
    //   if(querySnapshot.docs[i]["user_mail"] == userEmail){
    //     return true;
    //   }
    //   // print(querySnapshot.docs[i]["user_mail"]);
    // }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where("user_mail", isEqualTo : userEmail).get();

    if(querySnapshot.size>0){
      previousLoggedIn = true;
    }else{
      previousLoggedIn = false;
    }
  }


  Future<int> getTotalUsersCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs.length;
  }


  void _saveUsersData(int userId) {

    FirebaseFirestore.instance.collection("users").add({
      "user_id" : userId,
      "user_name": _userObj.displayName,
      "user_mail": _userObj.email,
      "user_photoUrl": _userObj.photoUrl,
    });
  }

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
                        SizedBox(
                          height: 1.5 * ResponsiveSize.blockSizeVertical,
                        ),
                        Text(
                          "Anywhere",
                          style: TextStyle(
                              fontSize: 4 * ResponsiveSize.blockSizeVertical,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 1 * ResponsiveSize.blockSizeHorizontal,
                    ),
                    Image.asset(
                      'assets/images/front_page_logo.png',
                      width: 8 * ResponsiveSize.blockSizeHorizontal,
                      height: 8 * ResponsiveSize.blockSizeVertical,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10 * ResponsiveSize.blockSizeHorizontal,
                    ),
                    Text(
                      "Auctions",
                      style: TextStyle(
                          fontSize: 2.8 * ResponsiveSize.blockSizeVertical,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 0.5 * ResponsiveSize.blockSizeHorizontal,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Be there",
                          style: TextStyle(
                            fontSize: 1 * ResponsiveSize.blockSizeVertical,
                          ),
                        ),
                        Text(
                          "From anywhere",
                          style: TextStyle(
                            fontSize: 1 * ResponsiveSize.blockSizeVertical,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50 * ResponsiveSize.blockSizeVertical,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async{
                    int userCount = await getTotalUsersCount();
                    // print(userCount);

                    _googleSignIn.signIn().then((userData) {
                      setState(() async{
                        checkPreviousSignIn(userData.email);
                        _userObj = userData;
                        // print(userData);
                        // print(userData.runtimeType);
                        if(userCount == 0){
                          _saveUsersData(userCount+1);
                        }else if(!previousLoggedIn){
                          _saveUsersData(userCount+1);
                        }
                        // Get.to(HomePage(), arguments: [userData]);
                        setData();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (Route<dynamic> route) => false,
                        );
                      });
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Container(
                    width: 65 * ResponsiveSize.blockSizeHorizontal,
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: button_background,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google_icon.png',
                            width: 5 * ResponsiveSize.blockSizeHorizontal,
                            height: 5 * ResponsiveSize.blockSizeVertical),
                        SizedBox(
                          width: 1 * ResponsiveSize.blockSizeHorizontal,
                        ),
                        Text(
                          "Sign In with Google",
                          style: TextStyle(
                            fontSize: 2.5 * ResponsiveSize.blockSizeVertical,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1 * ResponsiveSize.blockSizeVertical,
                ),
                Text(
                  "Login to continue",
                  style: TextStyle(
                      fontSize: 2 * ResponsiveSize.blockSizeVertical,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
