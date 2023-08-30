import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/home.dart';
import 'kyc/kyc.dart';
import 'login_signup/mobile_number_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool progress = true;

  @override
  initState() {
    super.initState();
    check();
  }

  // Future<void> check() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //
  //   if ((preferences.getString("usertype")?? "") == "") {
  //     Timer(
  //       Duration(seconds: 3),
  //           () => Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (BuildContext context) => OTPScreen()),
  //             (Route<dynamic> route) => false,
  //       ),
  //     );
  //     print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
  //   } else {
  //     if (preferences.getString("usertype") == "kycPage") {
  //       Timer(
  //         Duration(seconds: 3),
  //             () => Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (BuildContext context) => KYCPage()),
  //               (Route<dynamic> route) => false,
  //         ),
  //       );
  //     } else {
  //       if (preferences.getString("usertype") == "login") {
  //         Timer(
  //           Duration(seconds: 3),
  //               () => Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (BuildContext context) => Home()),
  //                 (Route<dynamic> route) => false,
  //           ),
  //         );
  //       }
  //     }
  //   }
  // },
   Future<void> check() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");

    if ((preferences.getString("usertype")?? "") == "") {
      Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MobileScreen()),///Mobile Number Enter Screen
              (Route<dynamic> route) => false,
        ),
      );
      print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    } else {
      print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");

      if (preferences.getString("usertype") == "login") {
        print("9999999999999999999999999999999999999999999999");
        Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),/// Home Page
                (Route<dynamic> route) => false,
          ),
        );
      }
     /* if (preferences.getString("usertype") == "kycPage") {
        print("kdkdkkdkdkkdkdkd");
        Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => KYCPage()),///KYC Page
                (Route<dynamic> route) => false,
          ),
        );
      }*/
    }
  }
  ///new code shared prefrence
  // Future<void> check() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //
  //   if ((preferences.getString("usertype")?? "") == "") {
  //     Timer(
  //       Duration(seconds: 3),
  //           () => Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (BuildContext context) => OTPScreen()),
  //             (Route<dynamic> route) => false,
  //       ),
  //     );
  //     print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
  //   } else {
  //     print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
  //
  //     if (preferences.getString("usertype") == "login") {
  //       print("kdkdkkdkdkkdkdkd");
  //       Timer(
  //         Duration(seconds: 3),
  //             () => Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (BuildContext context) => KYCPage()),
  //               (Route<dynamic> route) => false,
  //         ),
  //       );
  //     }
  //     if (preferences.getString("usertype") == "kycPage") {
  //       print("kdkdkkdkdkkdkdkd");
  //       Timer(
  //         Duration(seconds: 3),
  //             () => Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (BuildContext context) => Home()),
  //               (Route<dynamic> route) => false,
  //         ),
  //       );
  //     }
  //   }
  // }
 /* Future<void> check() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if ((preferences.getString("usertype") ?? "") == "") {
      // User is not logged in, navigate to OTPScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MobileScreen()),
            (Route<dynamic> route) => false,
      );
    } else if (preferences.getString("usertype") == "login") {
      // User is logged in, navigate to LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => KYCPage()),
            (Route<dynamic> route) => false,
      );
    } else if (preferences.getString("usertype") == "kycPage") {
      // User has filled KYC, navigate to Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false,
      );
    } else {
      // Default case, navigate to OTPScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MobileScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }*/


  @override
  Widget build(BuildContext context) {
    double ssheight = MediaQuery.of(context).size.height;
    double ffwidth = MediaQuery.of(context).size.width;
    // var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white,
            ]
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                Image.asset(
                  "assets/Lummang_icon.png",
                  height: 250,
                  width: 200,
                ),
              ],
            ),
            CircularProgressIndicator(
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}