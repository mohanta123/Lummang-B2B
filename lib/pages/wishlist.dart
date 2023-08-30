import 'dart:async';
import 'dart:convert';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_store/functions/localizations.dart';
import 'package:flutter_badged/badge_position.dart';
import 'package:flutter_badged/badge_positioned.dart';
import 'package:flutter_badged/flutter_badge.dart';
// My Own Import
import 'package:my_store/pages/home/home.dart';
import 'package:my_store/pages/product/product_deatils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls/urls.dart';
import 'my_cart.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
 bool  isLoaded= true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoaded = false;
      });
    });
    super.initState();
    getWishlist();
    getsDetails();
    getCartlist();
   // _timer = Timer.periodic(Duration(seconds: refreshIntervalInSeconds), (Timer timer)
   //  {
   //    getCartlist();
   //  });
  }

 @override
 void dispose() {
   // _timer.cancel();
   super.dispose();
 }

 //   Timer _timer;
 // int refreshIntervalInSeconds = 3;
 List<dynamic> ncartlist = [];
 void getCartlist() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String api = getAddtocartlist + prefs.getString("marketUsersId").toString();
   final response = await http.get(Uri.parse(api));
   if (response.statusCode == 200) {
     var mjson = json.decode(response.body);
     setState(() {
       ncartlist = mjson["data"];
     });
    // print(mjson);
   } else {
     print('api Error');
   }
 }

  String mobileNumber = "";
  String marketUsersId = "";
  void getsDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUsersId = prefs.getString("marketUsersId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
    });
    print("yyyyyyyyyyyyyyyyyyyyyyyyyyy=="+marketUsersId);
  }

  List nwishlist = [];
  void getWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api =
        getMyWishlistListByMarketUser + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print(mjson);
      setState(() {
        nwishlist = mjson["data"];
      //  minOrderQuantity = mjson["data"]["minOrderQuantity"].toString();
      });
    } else {
      print('api Error');
    }
  }

  ///Removed the Wishlist
  void getRemoveItem(String myWishlistId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var nencoded =
        Uri.parse(deleteWishList + myWishlistId );
    print("99999999999999999999"+ myWishlistId);
    //print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFf"+marketUserId);
    http.get(nencoded).then((resp) {
      print(resp.statusCode);
      print(myWishlistId);
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson);
        getWishlist();
        showInSnackBar("Item Removed From Wishlist");
      }
    });
  }

  int Quantity = 1;
  ///item move to Cart
  Future moveToCart(String sellerProductId, String minOrderQuantity) async {
    Map mjson;
    print(json.encode({
      'sellerProductId': sellerProductId.toString(),
      'createdBy': int.parse(marketUsersId).toString(),
      'quantity': minOrderQuantity.toString()
    }));
    http
        .post(Uri.parse(itemAddtoCart),
            headers: {"content-type": "application/json"},
            body: jsonEncode({
              'sellerProductId': sellerProductId.toString(),
              'createdBy': int.parse(marketUsersId).toString(),
              'quantity': minOrderQuantity.toString()
            }))
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        mjson = json.decode(response.body);
        getWishlist();
        showInSnackBar("Item Moved To Cart");
      } else {
        print("error");
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wishlist",
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
      // appBar: PrimaryAppBar.nameofAppBar(context),

      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedBox(
                width: size.width,
                child: nwishlist.isEmpty
                    ?
                /// List is Empty:
                    Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.10,
                          ),
                          Center(
                            child: Image(
                              image: AssetImage("assets/empty_cart.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            "Your Wishlist is empty right now :(",
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
                    : GridView.builder(
                        itemCount: nwishlist.length,
                      //  physics: NeverScrollableScrollPhysics(),
                        //shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                          nwishlist[index]["sellerProductId"]
                                              .toString())));
                            },
                            child: Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: Colors.grey
                              ),
                              child: Card(
                                child: Column(
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child:isLoaded ?FadeShimmer(
                                        height: 180,
                                        width: 200,
                                        baseColor: Colors.grey[400],
                                        highlightColor: Colors.grey[200],
                                      ): Image.network(
                                        imageBaseUrl +
                                            nwishlist[index]["productCoverImage"],
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: 180,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          /// Product Name
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 4.0),
                                            child:isLoaded?FadeShimmer(width: double.infinity, height: 20,
                                            baseColor: Colors.grey[400],highlightColor: Colors.grey[200],): Container(
                                              height: 20,
                                              width: 200,
                                              child: Text(
                                                nwishlist[index]["brandName"],
                                                // products.productTitle,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.5,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 03,
                                          ),

                                          /// Product Name
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: isLoaded? FadeShimmer(width: double.infinity, height: 20,
                                            baseColor: Colors.grey[400],
                                                highlightColor: Colors.grey[200],):
                                            Container(
                                              height: 20,
                                              width: double.infinity,
                                              child: Text(
                                                nwishlist[index]["itemTitle"],
                                                //"(${products.offerText})",
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 05,
                                          ),

                                          /// Product Details
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              // Price
                                              Container(
                                                height:20,
                                                width: 50,
                                                child:isLoaded?FadeShimmer(
                                                    width: double.infinity, height: 20,
                                                baseColor: Colors.grey[400],
                                                highlightColor: Colors.grey[200],): Text(
                                                    "\₹${nwishlist[index]["sellingPrice"]}",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.color,
                                                    ),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              SizedBox(width: 8.0),
                                              // Old Price
                                              /* Text(
                                        "99",
                                        //"\₹${products.productOldPrice}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            decoration: TextDecoration.lineThrough,
                                            color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),*/
                                              // SizedBox(width: 6.0),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: isLoaded?
                                                    FadeShimmer(width: 35, height: 35,
                                                      baseColor: Colors.grey[400],
                                                      highlightColor: Colors.grey[200],
                                                    ):

                                                InkWell(
                                                  child: Icon(Icons.delete,
                                                      color: Colors.black),
                                                  onTap: () {
                                                    getRemoveItem(nwishlist[index]
                                                            ["myWishlistId"]
                                                        .toString());
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 05,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  moveToCart(nwishlist[index]["sellerProductId"].toString(),nwishlist[index]["minOrderQuantity"].toString(),);
                                                },
                                                child:isLoaded?
                                                FadeShimmer(width: 120, height: 35,
                                                baseColor: Colors.grey[400],
                                                highlightColor: Colors.grey[200],):Container(
                                                  height: 35,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 05,
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .shopping_bag_outlined,
                                                          color: Colors.white),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Add to Bag",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          // Product Rating
                                          /* Container(
                                  padding: EdgeInsets.only(top: 3, left: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Color(0xFF9b9b9c),
                                      ),
                                    ],
                                  ),
                                ),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
