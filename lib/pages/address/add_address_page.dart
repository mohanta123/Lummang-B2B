import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/urls/urls.dart';


class AddAddressPage extends StatefulWidget {
  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String mobileNumber = "";
  String marketUserId = "";
  void getsDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = prefs.getString("marketUserId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
    });
    print(prefs.getString("marketUserId"));
  }

  @override
  void initState() {
    super.initState();
    getAddressList();
    getsDetails();
  }

  List nAddressList = [];
  void getAddressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api =
        getAddressListByMarketUser + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(prefs.getString("marketUserId"));
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print(mjson);
      setState(() {
        nAddressList = mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        title: Text(
          'Add Address',
          style: const TextStyle(
              // color: darkGrey,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
      ),
      body: ListView.builder(
        itemCount: nAddressList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text(nAddressList[index]["fullName"].toString()),
                    Text(nAddressList[index]["mobileNumber"].toString()),
                    Text(nAddressList[index]["emailId"].toString()),
                    Text(nAddressList[index]["addressLine1"].toString()),
                    Text(nAddressList[index]["country"].toString()),
                    Text(nAddressList[index]["state"].toString()),
                    Text(nAddressList[index]["city"].toString()),
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}
