import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants/urls/urls.dart';
import '../../constants/utils/custom_color.dart';
import '../home/home.dart';
import '../kyc/kyc.dart';
import 'forgot_password.dart';

var myOtp;
class LoginScreen extends StatefulWidget {

  final String mobileNo, userType;
  final int marrketUsersId;
  LoginScreen(this.mobileNo, this.userType, this.marrketUsersId);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _otp_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getsDetails();
  }

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void eyePressed() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String UserType = "2";
  String mobileNumber = "";
  String marketUsersId = "";
  void getsDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUsersId = prefs.getString("marketUsersId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
    });
    print(prefs.getString("marketUsersId"));
  }

/// Login
  bool _isLoading = false;
  Future<void> loginID() async {
    if (_isLoading) {
      return; // Prevent multiple requests while already loading
    }

    setState(() {
      _isLoading = true;
    });

    try {
      setState(() {
        isLoading = true;
      });
      String api = loginApi + widget.mobileNo.toString() + "/" + passwordController.text;
      final response = await http.get(Uri.parse(api));
      print(api);
      if (response.statusCode == 200){
        Map mjson = json.decode(response.body);

        print(mjson);
        print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("mobileNumber", mjson["obj"]["mobileNumber"].toString());
        print("++++++++++++++++++++++++++++++++++"+prefs.getString("mobileNumber").toString());
        prefs.setString("marketUsersId", mjson["obj"]["marketUserId"].toString());
        print("++++++++++++++++++++++++++++++++++"+prefs.getString("marketUserId").toString());
        prefs.setString("userType", widget.userType);
        prefs.setString("usertype", "login");
        getBuyerKYCList();
      } else {
        //Navigator.of(context).pop();
        showInSnackBar("Invalid Password. Please try again",);
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

//  List nBuyerKYCListByMarketUserId = [];
  void getBuyerKYCList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getBuyerKYCListByMarketUserId + prefs.getString("marketUsersId").toString();
    print(prefs.getString("marketUsersId").toString());
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      // if (mjson["data"].length > null) {
      //   print("777777777777777777777777777777777777777777777777777777");
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => Home()),
      //           (Route<dynamic> route) => false);
      // } else {
      //   print("99999999999999999999999999999999999999999999999");
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               KYCPage()));
      // }
      if (mjson != null && mjson["data"] != null && mjson["data"].length > 0) {
        print("777777777777777777777777777777777777777777777777777777");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
        );
      } else {
        print("99999999999999999999999999999999999999999999999");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KYCPage(widget.marrketUsersId)),
        );
      }

    } else {
      print('get Kyc api Error');
    }
  }
  Future<void> mobileNoCheck(String mobileNo) async {
    if (_isLoading) {
      return; // Prevent multiple requests while already loading
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var encoded = Uri.parse(sendOtp + mobileNo + "/" + UserType);
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
          print(_otp_controller);
          if (itemCount == myOtp.toString()) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ForgotPasswordPage(widget.mobileNo,widget.marrketUsersId)));
          }
        } else {
          // Navigator.pop(context);
          showInSnackBar("Something Going Wrong. Please Try again later.");
        }
      }).catchError((onError) {});
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  /// Forgotten password?
  // Future ForgottenPassword() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Map mjson;
  //   print(json.encode(
  //       {
  //         'marketUsersId':MARKETUserId,
  //         'password': passwordController.text,
  //         'mobileNumber': widget.mobileNo,
  //         'userType':  widget.userType,
  //       }));
  //   final http.Response response = await http.post(
  //     Uri.parse(updateMarketUser),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'marketUsersId':MARKETUserId,
  //       'password': passwordController.text,
  //       'mobileNumber': widget.mobileNo,
  //       'userType':  widget.userType,
  //     }),
  //   );
  //   if ("${response.statusCode}" == "200"){
  //     mjson = json.decode(response.body);
  //     // prefs.setString("marketUsersId", mjson["marketUsersId"].toString());
  //     // prefs.setString("mobileNumber", mjson["mobileNumber"].toString());
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => KYCPage(marrketUsersId)),
  //             (Route<dynamic> route) => false
  //     );
  //   } else {
  //     print("error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("OOOOOOOOOOOllllllOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO=="+widget.marrketUsersId.toString());
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: Colors.white,
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
                    Colors.white60,
                    Colors.white60,
                    Colors.white60,
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
                    height: 320,
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
                            padding: const EdgeInsets.only(right: 10,left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Welcome\nBack!",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color:
                                                  Color.fromARGB(255, 69, 42, 189))),
                                        ],
                                      )),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone_android,size: 22),
                                      SizedBox(width: 10,),
                                      Text(
                                        //"45666546546",
                                        widget.mobileNo,
                                        style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Container(
                                    // padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      //obscureText: true,
                                      controller: passwordController,
                                      validator: (value) {
                                        if ( value.isEmpty) {
                                          return 'Please Enter Password';
                                        } else {
                                          return null;
                                        }
                                      },
                                      obscureText: _obscureText,
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
                                        labelText: 'Enter Password',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        mobileNoCheck(widget.mobileNo);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ForgotPasswordPage()));
                                      },
                                      child: Text(
                                        "Forgotten password?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 69, 42, 189),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 25,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: SizedBox(
                                    height: 40,
                                    width: 280,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        loginID();
                                      },
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: PrimaryColor,
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
