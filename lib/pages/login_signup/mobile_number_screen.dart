import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/urls/urls.dart';
import '../../functions/prefs_file.dart';
import '../../functions/showToast.dart';
import '../kyc/kyc.dart';
import 'login_screen_page.dart';
import 'otp-verify.dart';

var myOtp;

var gst_no = "";

class MobileScreen extends StatefulWidget {


  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController _mob_controller = TextEditingController();
  final TextEditingController _otp_controller = TextEditingController();
  TextEditingController countryController = TextEditingController();

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  String UserType = "2";
 // String MARKETUSERID = "";
  List MARKETUSERIDDATA =[];
  int MARKETUSERID=0;

  bool _isLoading = false;
  Future<void> generateOtp() async {
    if (_isLoading) {
      return; // Prevent multiple requests while already loading
    }
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_mob_controller.text != "") {
        if (_mob_controller.text.length == 10) {
          var url =
              getMobileNumberExistance + _mob_controller.text + '/' + UserType;

          /// Await the http get response, then decode the json-formatted response.
          var response = await http.get(Uri.parse(url));
          print(_mob_controller.text);

          var mjson;
          if (response.statusCode == 200) {
            mjson = json.decode(response.body);
           // String jsonString = json.encode(mjson);
            int marketuserID=0;
            setState(() {
              MARKETUSERIDDATA = mjson["data"];
            });
           // marketuserID = mjson["data"]["marketUsersId"];
           // MARKETUSERID  = int.parse(marketuserID.toString());
            /// preferences.setString("usertype", "login");
            ///
            print(response.statusCode);
            print(mjson);
            if (mjson["data"].length > 0) {
               marketuserID = mjson["data"][0]["marketUsersId"];
              print("gfcggghgygv777777777777777777777777777"+marketuserID.toString());
              showInSnackBar("Your phone number is already registered.");
             // Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(_mob_controller.text, userType,marketuserID)));
            } else {
              showInSnackBar("You qualify for the Lummang App");
              mobileNoCheck();
            }
          }
        }
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  var myOtp;
  String userType = "2";
  Future mobileNoCheck() async {
    if (_mob_controller.text != "") {
      if (_mob_controller.text.length == 10) {
        print(sendOtp + _mob_controller.text + "/" + userType);
        var encoded =
        Uri.parse(sendOtp + _mob_controller.text + "/" + userType);
        http.get(encoded).then((value) async {
          print(value.statusCode);
          if (value.statusCode == 200) {
            var jsonResponse = jsonDecode(value.body);
            var itemCount = jsonResponse['otp'];
            print("7777777777777777777777777777777777777");
            Map mjson;
            mjson = json.decode(value.body);
            myOtp = itemCount;
            print('otp: $itemCount');
            print(value);
            print(myOtp);
            print(_otp_controller.text);
            if (itemCount == myOtp.toString()) {
              print("66666666633333333333366666666666666666666666666666666");
              // Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OTPVerify(_mob_controller.text, userType)));
            }
          } else {
            // Navigator.pop(context);
            showInSnackBar("Something Going Wrong. Please Try again later.");
          }
        }).catchError((onError) {});
      } else {
        showInSnackBar("Mobile Number Should Be 10 Digits");
      }
    } else {
      showInSnackBar("Please Enter Mobile Number");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(

                    children: [
                      SizedBox(height: deviceHeight*0.06,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 05,
                            ),
                            Image(
                              image: AssetImage(
                                'assets/Logo_Latter.png',
                              ),
                              //  width: 160,
                              width: deviceWidth * 0.40,
                              fit: BoxFit.contain,
                              //color: Colors.deepPurple,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.08,
                      ),
                      Image(
                        image: AssetImage(
                          'assets/loginscreen.png',
                        ),
                        width: deviceWidth * 0.75,
                        height: deviceHeight * 0.25,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height:deviceHeight * 0.20 ,),
                      Text(
                        'Login/Register With Phone Number',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      SizedBox(height: deviceHeight*0.01,),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: countryController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "|",
                                    style: TextStyle(fontSize: 33, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                        // maxLength: 10,
                                        controller: _mob_controller,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            ShowToast().showToast(
                                                "Please Enter your Mobile Number");
                                          } else if (val.length < 10) {
                                            ShowToast()
                                                .showToast("Incorrect mobile number");
                                          } else {
                                            return null;
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Phone Number*",
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            /*  TextFormField(

                            controller: _mob_controller,
                            validator:  (val) {
                              if(val.isEmpty){
                                ShowToast().showToast("Please Enter your Mobile Number");

                              }else if(val.length < 10){
                                ShowToast().showToast("Incorrect mobile number");
                              }else{
                                return null;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android_rounded),
                              suffixIcon: TextButton(
                                onPressed: (){
                                  if (_mob_controller.text.isEmpty) {
                                    ShowToast().showToast(
                                        "Please Enter a Valid Mobile Number");
                                  } else if (_mob_controller.text.length != 10) {
                                    ShowToast().showToast(
                                        "Please Enter a Valid Mobile Number");
                                  } else {
                                    setState(() {
                                      generateOtp(_mob_controller.text);
                                      ShowToast().showToast("Sending OTP");
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF526FD8),
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: Text('Generate OTP',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    )
                                ),
                              ),
                              labelText: 'Phone Number*',
                              labelStyle: const TextStyle(color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),*/
                            SizedBox(
                              height: deviceHeight * 0.01,
                            ),

                            /* TextFormField(
                            controller: _otp_controller,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                ShowToast().showToast('Press Generate OTP');
                              }else if(value.length < 5){
                                ShowToast().showToast('Invalid OTP');
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'OTP',
                              labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                              contentPadding: const EdgeInsets.all(20.0),
                              enabledBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all( Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),*/
                            // SizedBox(height: deviceHeight * 0.02,),

                            SizedBox(
                              height: deviceHeight * 0.06,
                              width: deviceWidth,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isChecked) {
                                    generateOtp();
                                    print('Checkbox is checked');
                                  } else {
                                    // Checkbox is not checked
                                    // Display an error message or show a snackbar
                                    showInSnackBar("Something Going Wrong.Select Terms and Privacy Policy.");
                                  }
                                  //mobileNoCheck();

                                },
                                child: Text('Next',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0)),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF526FD8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                    )),
                              ),
                              /* child:ElevatedButton(
                              onPressed: () async {
                                if(formKey.currentState.validate()){
                                  if(_otp_controller.text == myOtp.toString()) {
                                    print(myOtp);
                                    if(gst_no == "" || gst_no == null){
                                      Navigator.pushNamed(context, 'kyc', arguments: {"mob": _mob_controller.text});
                                    }else {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('logstatus', "loggedin");
                                      prefs.setString("regphone", _mob_controller.text);
                                      ShowToast().showToast("Logged In Successfully");
                                      Navigator.pushNamed(context, 'kyc', arguments: {"mob": _mob_controller.text});
                                    }
                                  }else {
                                    print("OTP Mismatch");
                                    ShowToast().showToast("Invalid OTP");
                                  }
                                }

                              },
                              child: Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0)
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF526FD8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  )
                              ),
                            ),*/
                            ),
                            SizedBox(
                              height: deviceHeight * 0.004,
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool value) {
                                    // This is where we update the state when the checkbox is tapped
                                    setState(() {
                                      isChecked = value;
                                    });
                                  },
                                ),
                                RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'I have read and understood the\n',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey)),
                                        TextSpan(
                                            text: 'Terms and Privacy Policy',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.deepPurple)),
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(
                  child: SpinKitFadingCircle(
                    // Colors.deepPurple.shade800,
                    color: Colors.deepPurple.shade800,
                    size: 80.0,
                  ),
                  //CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
