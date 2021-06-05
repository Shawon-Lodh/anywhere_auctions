import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  GoogleSignInAccount userData = Get.arguments[0];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anywhere Auction")),
      body: Container(
        child:Column(
          children: [
            Image.network(userData.photoUrl),
            Text(userData.displayName),
            Text(userData.email),
            TextButton(
                onPressed: () {
                  // _googleSignIn.signOut().then((value) {
                  //   setState(() {
                  //     _isLoggedIn = false;
                  //   });
                  // }).catchError((e) {});
                },
                child: Text("Logout"))
          ],
        )
      ),
    );
  }
}