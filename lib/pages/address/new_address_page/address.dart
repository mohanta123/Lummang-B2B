import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

import 'package:my_store/pages/address/new_address_page/slect_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../constants/urls/urls.dart';

class Address extends StatefulWidget {
  const Address({Key key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  void initState() {
    super.initState();
    // _razorpay = Razorpay();
    // _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getDetails();
    getAddressList();
  }

  ///Payment Gateway
 /* Razorpay _razorpay;
  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }
  void openPaymentPortal() async {
    var options = {
      'key': 'rzp_test_RtgMDUg83lFRra',
      'amount': 10000,
      'name': 'Padmalochana Mohanta',
      'description': 'Payment',
      'prefill': {'contact': '7978863499', 'email': 'mohanta@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }*/


  String mobileNumber = "";
  String marketUserId = "";
  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = prefs.getString("marketUserId");
      mobileNumber = prefs.getString("mobileNumber");
    });
  }

  /// List Data
  List AddressList = [];
  void getAddressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddressListByMarketUser + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
        AddressList = mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  int activeStep = 0;
  bool isLoading = false;
  double progress = 0.2;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Address",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: deviceHeight * 0.1,
            color: Colors.white,
            child: EasyStepper(
              activeStep: activeStep,
              lineLength: 80,
              lineSpace: 0,
              lineType: LineType.normal,
              defaultLineColor: Colors.grey,
              finishedLineColor: Color(0xFF526FD8),
              activeStepTextColor: Colors.black87,
              finishedStepTextColor: Colors.black87,
              internalPadding: 0,
              showLoadingAnimation: false,
              stepRadius: 8,
              showStepBorder: false,
              lineDotRadius: 1.5,
              steps: [
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          activeStep >= 0 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Order Confirmed',
                ),
                /*EasyStep(
                    customStep: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor:
                            activeStep >= 1 ? Color(0xFF526FD8) : Colors.white,
                      ),
                    ),
                      title: 'Packing',
                   // topTitle: true,
                  ),*/
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          activeStep >= 2 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Shipped',
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          activeStep >= 3 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Out For Delivery',
                  // topTitle: true,
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          activeStep >= 4 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Delivered',
                ),
              ],
              onStepReached: (index) => setState(() => activeStep = index),
            ),
          ),
          Divider(),
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("K.D",
                // AddressList[index]["fullName"].toString(),
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text(
                //AddressList[index]["addressLine1"].toString(),
                  "J-14,1st Floor,Lewis Rd ,Bjb Nagar,Bhubaneswar,Odisha,751014"
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text("BBSR"
                //AddressList[index]["landMark"].toString(),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text("GHJJJJSSJ"
                // AddressList[index]["pinCode"].toString(),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Row(
                children: [
                  Text("Mobile :"),
                  Text("7894561234",
                    //AddressList[index]["mobileNumber"].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    //new address
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectAddress()));
                  },
                  child: Container(
                    height: deviceHeight * 0.06,
                    width: double.infinity,
                    decoration:
                    BoxDecoration(border: Border.all(width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Center(
                        child: Text(
                          "CHANGE OR ADD ADDRESS",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
          Container(
            height: deviceHeight * 0.05,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "DELIVERY ESTIMATES",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: deviceHeight * 0.1,
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/WhatsApp Image 2023-05-02 at 15.46.44.jpeg",
                    width: deviceWidth * 0.1,
                    height: deviceHeight * 0.1,
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.02,
                ),
                Text("Delivery between"),
                SizedBox(
                  width: deviceHeight * 0.01,
                ),
                Text(
                  "Sat,22 Apr-Sun 23 Apr .",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
            onTap: () {
             /* navigatehome() async {
                await Future.delayed(Duration(seconds: 3), () {});
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SelectAddress()));
                //SelectHospital
              }
              setState(() {
                navigatehome();
                isLoading = true;
              });
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  isLoading = false;
                });
              });*/
             // openPaymentPortal();
            },
            child: Container(
              height: deviceHeight * 0.07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF526FD8)),
              child: Center(
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
            )),
      ),
    );

    //TimelinePage(title: 'M
  }
}
