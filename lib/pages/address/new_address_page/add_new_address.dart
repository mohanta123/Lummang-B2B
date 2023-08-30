import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:my_store/pages/address/new_address_page/slect_address.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../constants/urls/urls.dart';
import 'address.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  GlobalKey formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();
  TextEditingController AlternateMobile_controller = TextEditingController();
  TextEditingController pincode_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController locality_controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();
  int activeStep = 0;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    getDetails();
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

  Future addNewAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map mjson;
    // print(json.encode(
    //     {
    //       "fullName": name_controller.text,
    //       "mobileNumber": mobile_controller.text,
    //       "alternateMobileNumber": AlternateMobile_controller.text,
    //       "pinCode": pincode_controller.text,
    //       "addressLine1": address_controller,
    //       "landMark": locality_controller.text,
    //       "city": city_controller.text,
    //       "state": state_controller.text,
    //       "createdBy": marketUserId,
    //
    //     }));

   print(jsonEncode(<String, String>{
     "fullName": name_controller.text,
     "mobileNumber": mobile_controller.text,
     "alternateMobileNumber": AlternateMobile_controller.text,
     "pinCode": pincode_controller.text,
     "addressLine1": address_controller.text,
     "landMark": locality_controller.text,
     "city": city_controller.text,
     "state": state_controller.text,
     "createdBy": marketUserId,
   }));

    final http.Response response = await http.post(
        Uri.parse(createAddress),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "fullName": name_controller.text,
          "mobileNumber": mobile_controller.text,
          "alternateMobileNumber": AlternateMobile_controller.text,
          "pinCode": pincode_controller.text,
          "addressLine1": address_controller.text,
          "landMark": locality_controller.text,
          "city": city_controller.text,
          "state": state_controller.text,
          "createdBy": marketUserId,
        })
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      mjson = json.decode(response.body);
      // pref.setString("shopOwnerName", mjson["shopOwnerName"].toString());
      // pref.setString("shopeName", mjson["shopeName"].toString());
      // pref.setString("gstinNo", mjson["gstinNo"].toString());

      showInSnackBar("Save successfully");
      // AlertDialog(
      //   title: Text("Success"),
      //   content: Text("Save successfully"),
      // );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Address()),
              (Route<dynamic> route) => false
      );
    } else {
      print("error");
    }
  }
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text("Add New Address",style: TextStyle(color: Colors.black,
        fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: EasyStepper(
                  activeStep: activeStep,
                  lineLength: 70,
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
                              activeStep >= 0 ?Color(0xFF526FD8) : Colors.white,
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
                              activeStep >= 2 ? Color(0xFF526FD8) : Colors.white,
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Container(
                  height: deviceHeight*0.04,
                  child: Text(
                    "CONTACT DETAILS",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: name_controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Name*",
                            // hintText: "Name*",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: mobile_controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Mobile Number';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Mobile No*",
                            // hintText: "Mobile No*",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: AlternateMobile_controller,
                        decoration: InputDecoration(
                            labelText: "Alternate Mobile No",
                            // hintText: "Mobile No*",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Container(
                  height: deviceHeight*0.04,
                  child: Text(
                    "ADDRESS",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: pincode_controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Pin Code';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Pin Code*",
                            // hintText: "Name*",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: address_controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Address';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Address(House No, Building,Street,Area)*",
                            // hintText: "Mobile No*",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: locality_controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Locality';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Locality / Town*",
                            // hintText: "Name*",
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.grey.shade100,
                            width: deviceWidth*0.4,
                            child: TextFormField(
                              controller: city_controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter City';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: "City / District*",
                                  // hintText: "Name*",
                                  border: OutlineInputBorder(),
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade100,
                            width: deviceWidth*0.4,
                            child: TextFormField(
                              controller: state_controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter State';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: "State*",
                                  // hintText: "Name*",
                                  border: OutlineInputBorder(),
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                      value: isChecked,
                      activeColor: Color(0xFF526FD8),
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      }),
                  Text("Make this my default address")
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () async {
            if(_formKey.currentState.validate()){
              await addNewAddress();
            }

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => SelectAddress()));
          },
          child: Container(
            height:  deviceHeight*0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Color(0xFF526FD8)),
            child: Center(
              child: Text("Add Address",style: TextStyle(
                  color: Colors.white,fontSize: 20
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
