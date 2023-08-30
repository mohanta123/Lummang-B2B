import 'dart:convert';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:my_store/pages/address/new_address_page/payment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/urls/urls.dart';
import '../../payment_page/payment.dart';
import 'add_new_address.dart';
import 'address.dart';


class SelectAddress extends StatefulWidget {
  const SelectAddress({Key key}) : super(key: key);

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {




  int activeStep = 0;
  bool isChecked = false;
  bool isChcked1 = false;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    getDetails();
    getAddressList();
  }

  String mobileNumber ="";
  String marketUserId = "";
  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = prefs.getString("marketUserId");
      mobileNumber = prefs.getString("mobileNumber");
    });
  }

  /// List Data
  List AddressList=[];
  void getAddressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddressListByMarketUser + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200){
      var mjson = json.decode(response.body);
      setState(() {
        AddressList=mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text("Select Address",style: TextStyle(color: Colors.black,
        fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: deviceHeight * 0.2,
              color: Colors.white,
              child: Column(
                children: [
                  EasyStepper(
                    activeStep: activeStep,
                    lineLength: 70,
                    lineSpace: 0,
                    lineType: LineType.normal,
                    defaultLineColor: Colors.grey,
                    finishedLineColor:Color(0xFF526FD8),
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
                        title: 'Bag',
                      ),
                      EasyStep(
                        customStep: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor:
                                activeStep >= 1 ? Color(0xFF526FD8) : Colors.white,
                          ),
                        ),
                        //  title: 'Address',
                        topTitle: true,
                      ),
                      EasyStep(
                        customStep: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor:
                                activeStep >= 2 ?Color(0xFF526FD8) : Colors.white,
                          ),
                        ),
                        title: 'Preparing',
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
                        //   title: 'On Way',
                        topTitle: true,
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
                        title: 'Payment',
                      ),
                    ],
                    onStepReached: (index) => setState(() => activeStep = index),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        navigatehome() async {
                          await Future.delayed(Duration(seconds: 3), () {});
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => AddNewAddress()));
                          //SelectHospital
                        }
                        setState(() {
                          navigatehome();
                          isLoading=true;
                        });
                        Future.delayed(Duration(seconds: 3 ),(){
                          setState(() {
                            isLoading=false;
                          });
                        });
                        //new code
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => AddNewAddress()));
                      },
                      child: Container(
                        height: deviceHeight * 0.06,
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: isLoading? CircularProgressIndicator(color:  Color(0xFF526FD8),):Text(
                              "ADD NEW ADDRESS",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /// Default Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "DEFAULT ADDRESS",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700),
                ),
              ),
            ),
            Container(
              height: deviceHeight * 0.1,
              color: Colors.white,
              child: Row(
                children: [
                  Checkbox(
                      value: isChecked,
                      activeColor: Color(0xFF526FD8),
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "K.D",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Text("J-14, 1st floor, Lewis Rd,BJB Nagar, Bhubaneswar"),
                      Text("Odisha, India-751014"),
                    ],
                  ),
                ],
              ),
            ),
            /// Other Address
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Container(
                height: deviceHeight * 0.05,
                child: Text(
                  "OTHER ADDRESS",
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: AddressList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    height: deviceHeight * 0.3,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Checkbox(
                            value: isChcked1,
                            activeColor: Color(0xFF526FD8),
                            onChanged: (newBool) {
                              setState(() {
                                isChcked1 = newBool;
                              });
                            }),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AddressList[index]["fullName"],
                             // "PadmaLochan mohanata.",
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.01,
                            ),
                            Text(
                                AddressList[index]["addressLine1"]),
                            SizedBox(
                              height: deviceHeight * 0.01,
                            ),
                            Text(AddressList[index]["country"].toString()),
                            SizedBox(
                              height: deviceHeight * 0.01,
                            ),
                            Text(AddressList[index]["state"]),
                            SizedBox(
                              height: deviceHeight * 0.01,
                            ),
                            Text(AddressList[index]["pinCode"]),
                            SizedBox(
                              height: deviceHeight * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Mobile :",
                                ),
                                Text(AddressList[index]["mobileNumber"],
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              height: deviceHeight * 0.03,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: deviceHeight * 0.05,
                                  width: deviceWidth * 0.2,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1.3),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      )),
                                ),
                                SizedBox(width: deviceWidth * 0.06,),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => AddNewAddress()));
                                  },
                                  child: Container(
                                    height: deviceHeight * 0.05,
                                    width: deviceWidth * 0.2,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1.3),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                        child: Text(
                                          "EDIT",
                                          style: TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
       bottomNavigationBar: Padding(
    padding: const EdgeInsets.all(5.0),
    child: InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Address()));
      },
      child: Container(
      height:  deviceHeight*0.07,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5), color: Color(0xFF526FD8)),
      child: Center(
      child: Text("Confirm",style: TextStyle(
      color: Colors.white,fontSize: 20
      ),),
      ),
      ),
    ),
    ),
    );
  }
}
