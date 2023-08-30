import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/urls/urls.dart';
import '../../functions/showToast.dart';
import '../kyc/kyc.dart';
import 'mobile_number_screen.dart';

class OTPVerify extends StatefulWidget {
  final String mobileNo, userType;

  OTPVerify(this.mobileNo, this.userType);



  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  bool isLoading = false;
  String Mobile = "";



  @override
  void initState() {
    super.initState();
    //createRegister();

  }


  bool _isLoading = false;
  Future<void> createRegister() async {
    if (_isLoading) {
      return; // Prevent multiple requests while already loading
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map mjson;
      print(json.encode(
          {
            'password': passwordController.text,
            'mobileNumber': widget.mobileNo,
            'userType':  widget.userType,
          }));
      final http.Response response = await http.post(
        Uri.parse(createRegisterApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mobileNumber':widget.mobileNo,
          'password': passwordController.text,
          'userType': widget.userType
        }),
      );
      print(response.statusCode);
      if ("${response.statusCode}" == "200"){
        Map mjson = json.decode(response.body);
        int MarketUserId=0;
        MarketUserId = mjson["marketUsersId"];
        print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"+mjson.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("marketUsersId", mjson["marketUsersId"].toString());
        print("+++++++++++++++++++++"+prefs.getString("marketUsersId"));
        prefs.setString("mobileNumber", mjson["mobileNumber"].toString());
        print("--------------------------"+prefs.getString("mobileNumber"));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => KYCPage(MarketUserId)),
                (Route<dynamic> route) => false
        );
      } else {
        print("EErrror CreateRegister");
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  final formKey = GlobalKey<FormState>();
  final TextEditingController _otp_controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  void eyePressed() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(

          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [

                    Colors.white,
                    Colors.white,

                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 50),
                    child: Image.asset("assets/logo_items_design.png",),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 360,
                    width: 330,
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.grey,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          //shadowColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Verify Otp !\n",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color:
                                                  Color.fromARGB(255, 69, 42, 189))),
                                          TextSpan(
                                              text: 'Create Password',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Pinput(
                                    controller: _otp_controller,
                                    keyboardType: TextInputType.number,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        ShowToast().showToast('Press Generate OTP');
                                      }else if(value.length < 5){
                                        ShowToast().showToast('Invalid OTP');
                                      }
                                    },
                                    length: 5,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    submittedPinTheme: submittedPinTheme,

                                    showCursor: true,
                                    onCompleted: (pin) => print(pin),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    obscureText: _obscureText,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: _obscureText
                                            ? Icon(Icons.remove_red_eye_rounded,
                                            color:
                                            Color.fromARGB(255, 8, 72, 169))
                                            : Icon(Icons.remove_red_eye_outlined,
                                            color:
                                            Color.fromARGB(255, 8, 72, 169)),
                                        onPressed: () {
                                          eyePressed();
                                          print(_obscureText);
                                        },
                                      ),
                                      // border: OutlineInputBorder(),
                                      labelText: 'Create Password',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    height: 40,
                                    width: 280,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        createRegister();
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigo,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Center(
                child: SpinKitFadingCircle(
                  // Colors.deepPurple.shade800,
                  color: Color(0xFF526FD8),
                  size: 80.0,
                ),
                //CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

