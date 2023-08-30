import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls/urls.dart';
import '../functions/customStyle.dart';
import '../pages/my_cart.dart';
import '../pages/wishlist.dart';

class MYOrderPage extends StatefulWidget {
  @override
  State<MYOrderPage> createState() => _MYOrderPageState();
}

class _MYOrderPageState extends State<MYOrderPage> {
  @override
  void initState() {
    super.initState();
    getsDetails();
    getOrderlists();
    getCartlist();
  }

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

  /* void getOrderlists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getOrderList + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(prefs.getString("marketUserId"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData.containsKey("data")) {
        List<dynamic> orderData = jsonData["data"];
        List<OrderItem> orders = orderData
            .map((item) => OrderItem.fromJson(item["productDetails"]))
            .toList();
        setState(() {
          nOrderlist = orders;
        });
        print(nOrderlist);
      } else {
        print('Error: API response does not contain "data" field.');
      }
    } else {
      print('API Error: ${response.statusCode}');
    }
  }*/

  List<dynamic> nOrderlist = [];
  void getOrderlists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getOrderList + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(prefs.getString("marketUserId"));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" + mjson.toString());
      setState(() {
        nOrderlist = mjson["data"];
      });
     // print(nOrderlist);

    } else {
      print('api Error');
    }
  }

  List<dynamic> ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUserId").toString();
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
        ncartlist = mjson["data"];
      });
      print(mjson);
    } else {
      print('api Error');
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Processing":
        return Colors.indigo;
      case "Shipped":
        return Colors.green;
      case "Order Successfull":
        return Colors.blue;
      case "Order Cancelled":
        return Colors.red;
      default:
        return Colors.indigo; // Default color if the status doesn't match any of the cases above
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
      title: Text(
        "My Orders",
        style: TextStyle(
          fontFamily: 'Jost',
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          letterSpacing: 1.7,
        ),
      ),
      titleSpacing: 10.0,
      actions: [
        IconButton(
            icon: Icon(
              Icons.favorite_border_outlined,
              color: Color(0xFF526FD8),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WishList()));
            }),
        IconButton(
          padding: EdgeInsets.only(right: 15),
          icon: FlutterBadge(
            icon: Icon(Icons.shopping_cart_outlined),
            borderRadius: 20.0,
            itemCount: ncartlist.length,
          ),
          // (
          //     Icons.shopping_cart_outlined,
          //     color: Color(0xFF526FD8),
          //   ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyCart()));
          },
        ),
      ],
    ),
      body: nOrderlist.isEmpty
          ?  Column(
        children: [
          SizedBox(
            height: size.height * 0.10,
          ),
          Center(
            child: Container(
              height: 290,

              child: Image(
                image: AssetImage("assets/empty_order.png"),
                fit: BoxFit.fill,

              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            "Your Order is empty right now :(",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16),
          ),
          IconButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //         const AdvanceDietCreate()));
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          ),
        ],
      )
          : ListView.builder(
              itemCount: nOrderlist.length,
              itemBuilder: (context, index) {
                String cancellationMessage = nOrderlist[index]["productDetails"]["buyerOrderCanceledMassage"];
                bool hasCancellationMessage = cancellationMessage != null && cancellationMessage.isNotEmpty;
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Expanded(
                    child: Container(
                     // height:deviceHeight,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            /*  Container(
                                height: deviceHeight*0.030,
                                color: Colors.indigo,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    nOrderlist[index]["productDetails"]
                                    ["orderCurrentStatus"]
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),*/
                        Container(
                        height: deviceHeight * 0.030,
                        color: getStatusColor(nOrderlist[index]["productDetails"]["orderCurrentStatus"]),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            nOrderlist[index]["productDetails"]["orderCurrentStatus"].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                            ],
                          ),
                          Divider(thickness: 2,),
                          Container(
                             height: deviceHeight*0.13,
                            child: Row(
                              children: [
                                Container(
                                 // height: 100,
                                  width: deviceWidth*0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    imageBaseUrl +
                                        nOrderlist[index]["productDetails"]
                                        ["productCoverImage"]
                                            .toString(),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              VerticalDivider(thickness: 2,),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                   // height: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          nOrderlist[index]["productDetails"]
                                          ["itemTitle"]
                                              .toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              nOrderlist[index]["productDetails"]
                                              ["filterName"]
                                                  .toString(),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              "\ : ${nOrderlist[index]["productDetails"]["filterValueName"].toString()}",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text( "\ ₹ ${nOrderlist[index]["productDetails"]["sellingPrice"].toString()}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Container(
                                         // color: Colors.indigo,
                                          child: Text(
                                            nOrderlist[index]["productDetails"]["autoOrderId"]
                                                .toString(),
                                            style: TextStyle(color: Colors.indigo),
                                          ),
                                        ),
                                        Visibility(
                                          visible: hasCancellationMessage,
                                          child: Expanded(
                                            child: Text(
                                              cancellationMessage ?? '', // Show an empty string if the value is null
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(thickness: 2,),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
