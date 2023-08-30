import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:http/http.dart 'as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/urls/urls.dart';
import '../../../functions/customStyle.dart';
import '../../my_cart.dart';
import '../../product/product_deatils.dart';
import '../../search.dart';
import '../../wishlist.dart';

class SubscriptionProductsLists extends StatefulWidget {
  final String subscriptiontTypeId;
  final String TypeName;
  SubscriptionProductsLists(this.subscriptiontTypeId, this.TypeName);



  @override
  State<SubscriptionProductsLists> createState() => _SubscriptionProductsListsState();
}

class _SubscriptionProductsListsState extends State<SubscriptionProductsLists> {
  bool isLoaded = true;
  ///simmer
  @override
  void initState() {
    super.initState();
    subscriptiontTypeIdByProductList();
    getCartlist();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoaded = false;
      });
    });
  }

  List ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    // print(response.body);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      //print(mjson);
      setState(() {
        ncartlist = mjson["data"];
      });
      print(mjson);
    } else {
      print('api Error');
    }
  }

  List subscriptiontIdByProductList = [];
  void subscriptiontTypeIdByProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getProductListBySubscriptionsId + widget.subscriptiontTypeId.toString();
    final response = await http.get(Uri.parse(api));
    print(widget.subscriptiontTypeId.toString());
    print(response.statusCode);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      //print(mjson);
      setState(() {
        subscriptiontIdByProductList = mjson["data"];
      });
      print(mjson);
    } else {
      print('Error Error api Error');
    }
  }
  /*void subscriptiontTypeIdByProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getProductListBySubscriptionsId + "/" + widget.subscriptiontTypeId;

    try {
      final response = await http.get(Uri.parse(api));
      print(widget.subscriptiontTypeId);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var mjson = json.decode(response.body);
        setState(() {
          subscriptiontIdByProductList = mjson["data"];
        });
        print(mjson);
      } else {
        print('API Error');
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    print(widget.subscriptiontTypeId.toString());
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.TypeName,style: AppbarPrimaryTextStyle.nameofTextStyle(),),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                EvaIcons.search,
                color: Color(0xFF526FD8),
                size: 28,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Search()));
              }),
          IconButton(
              icon: Icon(
                EvaIcons.heartOutline,
                color: Color(0xFF526FD8),
                size: 28,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WishList()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyCart()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GridView.builder(
            itemCount: subscriptiontIdByProductList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetails(
                              subscriptiontIdByProductList[index]["sellerProductId"]
                                  .toString())));
                },
                child: Card(
                  child: Column(
                    children: [
                      /// Product Images
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: isLoaded
                            ? FadeShimmer(
                          width: 200,
                          height: 190,
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.grey[200],
                        )
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            imageBaseUrl +
                                subscriptiontIdByProductList[index]
                                ["productCoverImage"].toString(),
                            fit: BoxFit.fill,
                            width: 200,
                            height: 190,

                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8,),
                        child: Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            /// Product Name
                            Container(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: double.infinity,
                                height: deviceHeight * 0.02,
                                child: isLoaded
                                    ? FadeShimmer(
                                  width: double.infinity,
                                  height: deviceHeight * 0.03,
                                  baseColor: Colors.grey[400],
                                  highlightColor: Colors.grey[200],
                                )
                                    : Text(
                                  subscriptiontIdByProductList[index]
                                  ["brandName"],
                                  // products.productTitle,
                                  style: BrandNamePrimaryTextStyle
                                      .nameofTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),

                            /// Product Name
                            Container(
                              width: double.infinity,
                              height: deviceHeight * 0.02,
                              alignment: Alignment.topLeft,
                              child: isLoaded
                                  ? FadeShimmer(
                                width: double.infinity,
                                height: deviceHeight * 0.03,
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.grey[200],
                              )
                                  : Text(
                                subscriptiontIdByProductList[index]["itemTitle"],
                                //"(${products.offerText})",
                                style: TitlePrimaryTextStyle
                                    .nameofTextStyle(),
                              ),
                            ),

                            /// Product Details
                            isLoaded
                                ? FadeShimmer(
                              width: double.infinity,
                              height: deviceHeight * 0.03,
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[200],
                            )
                                : Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                // Old Price
                                Text(
                                  "\₹${subscriptiontIdByProductList[index]["mrp"]}",
                                  style: MrpPricePrimaryTextStyle
                                      .nameofTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 5.0),

                                /// Price
                                Text(
                                    "\₹${subscriptiontIdByProductList[index]["sellingPrice"]}",
                                    style: PricePrimaryTextStyle
                                        .nameofTextStyle(),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis),
                                // SizedBox(width: 6.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
