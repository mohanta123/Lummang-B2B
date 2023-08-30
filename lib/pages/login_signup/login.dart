import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/functions/showToast.dart';
import 'package:http/http.dart' as http;

// My Own Import
import 'package:shared_preferences/shared_preferences.dart';

var myOTP;

var gst_no = "";

Future<http.Response> postRequest(var mob) async {
  var url = 'https://demo22.appman.in/api/createotp';

  Map data = {'Phoneno': mob, 'usertype': 'buyer'};
  //encode Map to JSON
  var body = json.encode(data);

  var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
  var jsonResponse = jsonDecode(response.body);
  gst_no = jsonResponse['Gstcertificate'];
  print("${response.statusCode}");
  print("${response.body}");
  generateOtp(mob);
  return response;
}

Future<void> generateOtp(var mob) async {
  var url = 'https://demo22.appman.in/api/sms/sendsignupotp/' + mob;

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var itemCount = jsonResponse['otp'];

    myOTP = itemCount;
    print('otp: $itemCount');
    print('gstno: $gst_no');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class OTPLoginPage extends StatefulWidget {
  @override
  _OTPLoginPageState createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage> {
  final TextEditingController _mob_controller = TextEditingController();
  final TextEditingController _otp_controller = TextEditingController();

 // DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    Locale myLocale = Localizations.localeOf(context);

    return Scaffold(
      body: Container(
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100.0),
                    Image.asset(
                      'assets/round_logo.png',
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 110.0,
                    ),
                    Container(
                      width: width - 40.0,
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, right: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1.5,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: TextField(
                              controller: _mob_controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                prefixIcon: Icon(Icons.phone_android_rounded),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              if (_mob_controller.text.isEmpty) {
                                ShowToast().showToast(
                                    "Please Enter a Valid Mobile Number");
                              } else if (_mob_controller.text.length != 10) {
                                ShowToast().showToast(
                                    "Please Enter a Valid Mobile Number");
                              } else {
                                setState(() {
                                  postRequest(_mob_controller.text);
                                  ShowToast().showToast("Sending OTP");
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                child: Text(
                                  "Generate OTP",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Jost',
                                    fontSize: 16.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: TextField(
                              controller: _otp_controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "OTP",
                                prefixIcon: Icon(Icons.vpn_key),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: () async {
                              if (_mob_controller.text.isEmpty) {
                                ShowToast().showToast(
                                    "Please Enter a Valid Mobile Number");
                              } else if (_otp_controller.text.isEmpty) {
                                ShowToast()
                                    .showToast("Please Enter a Valid OTP");
                              } else {
                                if (_otp_controller.text == myOTP.toString()) {
                                  print(myOTP);
                                  if (gst_no == "" || gst_no == null) {
                                    Navigator.pushNamed(context, "kyc",
                                        arguments: {
                                          "mob": _mob_controller.text
                                        });
                                  } else {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('logstatus', "loggedin");
                                    prefs.setString(
                                        "regphone", _mob_controller.text);
                                    Navigator.pushReplacementNamed(
                                        context, "home");
                                  }
                                } else {
                                  print("OTP Mismatch");
                                  ShowToast().showToast("Invalid OTP");
                                }
                              }
                            },
                            child: Container(
                              height: 45.0,
                              width: (myLocale.languageCode == 'ru')
                                  ? 180.0
                                  : 140.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.redAccent,
                                color: Colors.red,
                                elevation: 7.0,
                                child: GestureDetector(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).translate(
                                          'loginPage', 'loginString'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Jost',
                                        fontSize: 16.0,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

      ),
    );
  }
}
