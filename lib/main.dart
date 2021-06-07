import 'package:anywhere_auction/Views/signIn_page.dart';
import 'package:anywhere_auction/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/auction_product_details.dart';
import 'Views/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  Constant.userEmail = pref.getString("user_email")??"";
  Constant.userName = pref.getString("user_name")??"";
  Constant.userPhotoUrl = pref.getString("user_photoUrl")??"";
  Constant.loggedIn = pref.getBool("login_status")??false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // home: AuctionProductDetails(),
      home : Constant.loggedIn == false? SignIn(): HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
