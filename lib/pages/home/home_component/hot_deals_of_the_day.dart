import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/urls/urls.dart';

class HotDealsOfTheDay extends StatefulWidget {
  const HotDealsOfTheDay({Key key}) : super(key: key);

  @override
  State<HotDealsOfTheDay> createState() => _HotDealsOfTheDayState();
}

class _HotDealsOfTheDayState extends State<HotDealsOfTheDay> {
  @override
  void initState() {
    super.initState();
    //productListBySubscription();
    gSubscriptionTypeList();
  }

  bool isAvalable = false;

  /// Subscription Type List
  List SubscriptionTypeList = [];
  List jSubscriptionTypeList = [];
  void gSubscriptionTypeList() async {
    String api = getSubscriptionTypeList;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map nmjson = json.decode(response.body);
      setState(() {
        SubscriptionTypeList = nmjson["data"];
      });
      productListBySubscription();
    } else {
      print('api Error');
    }
  }


  /// ProductList By Subscription
  List productsListBySubscription = [];
  void productListBySubscription() async {
    String api = getProductListBySubscriptions;
    final response = await http.get(Uri.parse(api));
    print("llllllllllllllllllllllllllllllllllllllllllll");
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      // print(mjson);
      setState(() {
        productsListBySubscription = mjson["data"];
      });
      for (int i = 0; i < SubscriptionTypeList.length; i++) {
        List ntproducts = [];
        for (int j = 0; j < productsListBySubscription.length; j++) {
          if (productsListBySubscription[j]["subscriptionTypeId"].toString() ==
              SubscriptionTypeList[i]["subscriptionTypeId"].toString()) {
            ntproducts.add(productsListBySubscription[j]);
          }
        }
        setState(() {
          jSubscriptionTypeList.add({
            "TypeName": SubscriptionTypeList[i]["subscriptionName"].toString(),
            "Image": productsListBySubscription[i]["productCoverImage"].toString(),
            "Products": ntproducts
          });
        });
      }
      print(
          "--------------------------------------------------------------------------");
      print(jSubscriptionTypeList);
    } else {
      print('api Error');
    }
  }



  // List SubscriptionImage = [
  // for (int i = 0; i < productsListBySubscription; i++){
  // var isAvalable = false ;
  // for(int j = 0; j < SubscriptionTypeList; j++){
  // if(mjson["data"]['subscriptionTypeId'] ==  nmjson["data"]['subscriptionTypeId']){
  // if (isAvalable == false) {
  //
  // }
  // }
  // }
  // }
  // ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: jSubscriptionTypeList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    jSubscriptionTypeList[index]["TypeName"].toString(),
                    // "Hot Deals of the Day",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // ScrollViewProducts(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: 210,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: jSubscriptionTypeList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                child: Card(
                                  //elevation: 3,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Container(
                                          width: 150,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: Image.network(
                                              imageBaseUrl +
                                                  jSubscriptionTypeList[index]
                                                          ["Image"]
                                                      .toString(),
                                              fit: BoxFit.fill),
                                        ),
                                        /* Container(
                                        width: 150,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                'assets/products/22.png',
                                              ),
                                              fit: BoxFit.fill),
                                        ),
                                      ),*/
                                      ),
                                      /* const SizedBox(height: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Smart Watch",
                                          // textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text("\₹1600",
                                          // textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),*/
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
