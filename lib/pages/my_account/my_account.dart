import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:my_store/constants/utils/custom_color.dart';
import 'package:my_store/pages/home/home.dart';
import 'package:my_store/pages/kyc/kyc.dart';

// My Own Imports
import 'package:my_store/functions/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/urls/urls.dart';
import '../../functions/customStyle.dart';
import '../../order_page/my_order.dart';
import '../../policy_file/privacy_policy.dart';
import '../../policy_file/return_and_refund.dart';
import '../../policy_file/terms_and_conditions.dart';
import '../address/add_address_page.dart';
import '../call_center/call_center.dart';
import '../login_signup/mobile_number_screen.dart';
import '../wishlist.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    super.initState();
    getBuyerDetails();
    getDetails();
  }

  String mobileNumber = "";
  String marketUsersId = "";
  String ShopOwnerName = "";
  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUsersId = prefs.getString("marketUsersId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
      ShopOwnerName = prefs.getString("ShopOwnerName").toString();
    });
  }

 // List nBuyerDetails = [];
  String ShopName = "";
  void getBuyerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getBuyerKYCListByMarketUserId + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      print(mjson);
      setState(() {
       // nBuyerDetails = mjson["data"];
        ShopName = mjson["data"]["shopeName"].toString();
      });

    } else {
      print('api Error');
    }
  }

  Color ordersTap = Colors.white;
  Color wishListTap = Colors.white;
  Color addressTap = Colors.white;
  Color couponsTap = Colors.white;
  Color helpcenterTap = Colors.white;
  Color inviteTap = Colors.white;
  Color returnTap = Colors.white;
  Color policyTap = Colors.white;
  Color tcTap = Colors.white;

  Color secoundTap = PrimaryColor.withOpacity(0.2);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    /// Logout AlertDialog Start Here
    logoutDialogue() {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: new Text("Confirmation"),
            content: new Text("Do you want to logout?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Yes",
                    style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  SharedPreferences preferences =
                  await SharedPreferences.getInstance();
                  preferences.clear();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MobileScreen()),
                          (Route<dynamic> route) => false);
                },
              ),
              CupertinoDialogAction(
                child: Text("Exit",
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));
    }
    /// Logout AlertDialog Ends Here

    return Scaffold(
      //   appBar: SecoundaryAppBar.nameofAppBar('Profile'),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .50,
                decoration: const BoxDecoration(
                  color: Color(0xFF526FD8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
              Positioned(
                top: deviceHeight * 0.04,
                left: deviceWidth * 0.02,
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //   ProfilePicture(
                    //   name: 'Aditya Dharmawan Saputra',
                    //   role: 'ADMINISTRATOR',
                    //   radius: 31,
                    //   fontsize: 21,
                    //   tooltip: true,
                    //   img: 'https://avatars.githubusercontent.com/u/37553901?v=4',
                    // ),

                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(50.0),
                    //   child: Image(
                    //     color: Colors.red,
                    //     image: AssetImage('assets/user_profile/user_2.jpg'),
                    //     height: 75.0,
                    //     width: 75.0,
                    //   ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ShopName.toString(),
                          //'PL Mahanta',
                          style: HeaderAccountTextStyle.nameofTextStyle(),
                        ),
                        SizedBox(height: 5),
                        Text(
                          mobileNumber.toString(),
                          // '7456214545',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'padma.appman@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: PrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.25,),
                    ProfilePicture(
                      name: ShopName,
                      radius: 31,
                      fontsize: 26,
                      random: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.25,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: deviceHeight * 0.8,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .15,
                      right: 25.0,
                      left: 25.0),
                  child: Card(
                    elevation: 50.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only( top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Profile
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ordersTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'My Profile',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(
                                    EvaIcons.arrowIosForward,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// Address
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                couponsTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAddressPage()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.navigation2Outline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Address',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// My Orders
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MYOrderPage()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.cubeOutline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Your Order',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// WishList
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                wishListTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WishList()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.heartOutline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'WishList',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// Help Center
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                wishListTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CallCenter()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.questionMarkCircleOutline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Help Center',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// Coupons
                          /*  GestureDetector(
                            onTap: (){
                              setState(() {
                                couponsTap = secoundTap;
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                            },

                            child: Container(
                                margin: EdgeInsets.only(bottom: 4),
                                height: deviceHeight * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: couponsTap,
                                  boxShadow: <BoxShadow>[
                                    // BoxShadow(
                                    //   blurRadius: 6,
                                    //   blurStyle: BlurStyle.outer,
                                    //   spreadRadius: 0.1,
                                    //   color: Colors.grey.withOpacity(0.3),
                                    // ),
                                  ],
                                ),
                                child:
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Icon(EvaIcons.giftOutline,
                                        size: 26,
                                      ),
                                      const SizedBox(width: 20,),
                                      const Text('Coupons',
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 0.2,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                       Icon(EvaIcons.arrowIosForward)
                                    ],
                                  ),
                                )
                            ),
                          ),*/

                          /// Privacy Policy
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tcTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrivacyPolicy()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.shieldOutline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Privacy Policy',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// Terms & Conditions
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tcTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TermsAndCondition()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.fileOutline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Terms & Conditions',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),

                          /// Return and Refund policy
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tcTap = secoundTap;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReturnAndRefundPolicy()));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    EvaIcons.fileAddOutline,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Return and Refund policy',
                                    style: AccountTextStyle.nameofTextStyle(),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(EvaIcons.arrowIosForward)
                                ],
                              ),
                            ),
                          ),

                          /// Log Out Button
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: deviceWidth,
                              height: deviceHeight * 0.05,
                              child: ElevatedButton(
                                onPressed: () {

                                  logoutDialogue();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: PrimaryColor,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15))),
                                child: Text(
                                  'Log Out',
                                  style:
                                      HeaderAccountTextStyle.nameofTextStyle(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
