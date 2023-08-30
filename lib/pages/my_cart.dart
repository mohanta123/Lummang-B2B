import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:my_store/pages/product/product_deatils.dart';
import 'package:my_store/pages/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

// My Own Import
import 'package:my_store/pages/home/home.dart';
import '../constants/urls/urls.dart';
import '../functions/customStyle.dart';
import 'address/new_address_page/address.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  double sellingtotal = 0;
  double SingleCalAmount = 0;
  double Mrptotal = 0;
  int TotalMrp = 0;
  bool isLoading = false;
  bool isLoaded = true;
  bool isLoaded1 = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      this.getDetails();
      setState(() {
        isLoaded1 = false;
      });
    });
    getCartlist();
    // DeliveryChargeAmount();
  }

  String mobileNumber = "";
  String marketUserId = "";
  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = prefs.getString("marketUsersId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
    });
  }

  /// Removed the Add to Cart
  void getAddtoCartRemoveItem(String sellerProductId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(
        getDeleteAddtoCart + sellerProductId + "/" + marketUserId.toString());
    print(sellerProductId);
    print(marketUserId);
    http.get(nencoded).then((resp) {
      print(resp.statusCode);
      print(sellerProductId);
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson);
        getCartlist();
        showInSnackBar("Item Removed From Add to Card");
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  /// Add to Cart Calculation
  double TotalAmount = 0;
  List ncartlist = [];

  List<String> DeliveryCharges = [];
  double TotalPercentage = 0;
  double discountPercentage = 0;
  int totalPriceInt = 0;
  int TotalSingleAmount = 0;
  int TotalDiscountAmount = 0;
  List totalPercentageInt = [];
  List totalSingleAmountInt = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
        ncartlist = mjson["data"];
        print(mjson);

      });
      if (mjson["data"].length > 0) {
        double MrpDiscount = 0;
        double totalPrice = 0;
        int SingleSellingPrice = 0;
        double SingleAmount = 0;
        double Percentage = 0;
        double TotalDiscount = 0;
        for (int i = 0; i < mjson["data"].length; i++) {
          var quantity = mjson["data"][i]["quantity"];

          /// DeliveryCharges
          var DCharges = mjson["data"][i]["freeDelivery"];
          DeliveryCharges.add(DCharges);
          DeliveryChargeAmount();

          /// Parse the sellingPrice and mrp after removing commas
          var sellingPriceString =
              mjson["data"][i]["sellingPrice"].toString().replaceAll(',', '');
          var mrpString =
              mjson["data"][i]["mrp"].toString().replaceAll(',', '');

          SingleAmount = double.parse(sellingPriceString) * quantity;
          print("-------------------" + SingleAmount.toString());

          /// Convert the parsed strings to doubles
          var sellingPrice = double.parse(sellingPriceString);
          var mrp = double.parse(mrpString);

          double sellingPriceTotal = quantity * sellingPrice;
          double mrpTotal = quantity * mrp;

          /// Calculate the discount amount
          double discountAmount = mrp - sellingPrice;

          /// Calculate the discount percentage
          double discountPercentage = (discountAmount / mrp) * 100;

          Percentage = discountPercentage;

          /// Print the discount amount and percentage

          totalPrice += sellingPriceTotal;
          SingleSellingPrice = sellingPriceTotal.toInt();
          MrpDiscount += mrpTotal;
          TotalPercentage = Percentage;
          totalPercentageInt.add(TotalPercentage.toInt());
          // if (SingleAmount != null) {
          //   totalSingleAmountInt.add(SingleAmount.toInt());
          // }
          totalSingleAmountInt.add(SingleAmount.toInt());

          /// Calculate the discount
          TotalDiscount = MrpDiscount - totalPrice;
        }
        setState(() {
          TotalAmount = totalPrice;
          totalPriceInt = TotalAmount.toInt();
          TotalMrp = MrpDiscount.toInt();
          TotalDiscountAmount = TotalDiscount.toInt();
          TotalSingleAmount = SingleAmount.toInt();
        });
      }

      print(totalPriceInt);
      print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
      print("DeliveryCharges----" + DeliveryCharges.toString());
    } else {
      print('API Error');
    }
  }

  /// Decrease Quantity
  Future decreaseQuantity(String addtoCartId) async {
    Map mjson;
    print(json.encode({
      'addtoCartId': addtoCartId,
      'createdBy': marketUserId,
    }));
    http
        .post(Uri.parse(updateMinusQuantity),
            headers: {"content-type": "application/json"},
            body: jsonEncode({
              'addtoCartId': addtoCartId,
              'createdBy': marketUserId,
            }))
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        mjson = json.decode(response.body);
        getCartlist();
        // getSingleSellerProductDetails();
      } else {
        print("error");
      }
    });
  }

  /// Increase Quantity
  Future increaseQuantity(String addtoCartId) async {
    Map mjson;
    print(json.encode({
      'addtoCartId': addtoCartId,
      'createdBy': marketUserId,
    }));
    http
        .post(Uri.parse(updatePlusQuantity),
            headers: {"content-type": "application/json"},
            body: jsonEncode({
              'addtoCartId': addtoCartId,
              'createdBy': marketUserId,
            }))
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        mjson = json.decode(response.body);
        setState(() {
          Fluttertoast.showToast(
              msg: "Product Qty Updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.pink,
              textColor: Colors.black,
              fontSize: 15.0);
        });
        getCartlist();
        // getSingleSellerProductDetails();
        getDetails();
      } else {
        print("error");
        Navigator.pop(context);
      }
      getDetails();
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Please wait...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: AppbarPrimaryTextStyle.nameofTextStyle(),
        ),
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.favorite_border_outlined,
                color: Color(0xFF526FD8),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
          ),
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: ncartlist.isNotEmpty
                  ?

                  /// List is Not Empty:
                  Scaffold(
                      body: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: ncartlist.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            ncartlist[index]["sellerProductId"]
                                                .toString())));
                              },
                              child: Card(
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD7F8E2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: isLoaded1
                                            ? FadeShimmer(
                                                height: 100,
                                                width: 80,
                                                baseColor: Colors.grey[400],
                                                highlightColor:
                                                    Colors.grey[200],
                                              )
                                            : Image.network(
                                                imageBaseUrl +
                                                    ncartlist[index]
                                                        ["productImage1"],
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: double.infinity,
                                              child: isLoaded1
                                                  ? FadeShimmer(
                                                      height: 20,
                                                      width: double.infinity,
                                                      baseColor:
                                                          Colors.grey[400],
                                                      highlightColor:
                                                          Colors.grey[200],
                                                    )
                                                  : Text(
                                                      ncartlist[index]
                                                          ["brandName"],
                                                      style: PrimaryTextStyle
                                                          .nameofTextStyle(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 03,
                                            ),
                                            Container(
                                              height: 20,
                                              width: double.infinity,
                                              child: isLoaded1
                                                  ? FadeShimmer(
                                                      height: 20,
                                                      width: double.infinity,
                                                      baseColor:
                                                          Colors.grey[400],
                                                      highlightColor:
                                                          Colors.grey[200],
                                                    )
                                                  : Text(
                                                      ncartlist[index]
                                                          ["itemTitle"],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          AddtoCartTitleNamePrimaryTextStyle
                                                              .nameofTextStyle(),
                                                    ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            isLoaded1
                                                ? FadeShimmer(
                                                    height: 10,
                                                    width: 100,
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                  )
                                                : Row(
                                                    children: [
                                                      /// Old Price mrp
                                                      Container(
                                                        child: Text(
                                                          ncartlist[index]
                                                              ["mrp"],
                                                          style: MrpPricePrimaryTextStyle
                                                              .nameofTextStyle(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.0),

                                                      /// Selling Price
                                                      Text(
                                                        "\₹ ${ncartlist[index]["sellingPrice"]}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      // Text("\ $totalPercentageInt% off",style: TextStyle(color: Colors.black),),
                                                      Text(
                                                        totalPercentageInt[
                                                                    index]
                                                                .toString() +
                                                            "% off",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            isLoaded1
                                                ? FadeShimmer(
                                                    height: 10,
                                                    width: 100,
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                  )
                                                : Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // decreaseQuantity(ncartlist[index]["addtoCartId"].toString());
                                                            // ncartlist[index]["Quantity"] = ncartlist[index]["minOrderQuantity"];

                                                            // if (ncartlist[index]["minOrderQuantity"] < ncartlist[index]["Quantity"]) {
                                                            //   // Decrease the quantity only if it's greater than the minimum order quantity
                                                            //   decreaseQuantity(ncartlist[index]["addtoCartId"].toString());
                                                            //   // getCartlist();
                                                            //   // getAddtoCartRemoveItem(ncartlist[index]["addtoCartId"].toString());
                                                            // }

                                                            for (int index = 0; index < ncartlist.length; index++) {
                                                              print("AAA");

                                                              var minOrderQuantity = ncartlist[index]["minOrderQuantity"];
                                                              var quantity = ncartlist[index]["quantity"];
                                                              print("-----------------quantity-------------" + quantity.toString());
                                                              print("-----------minOrderQuantity------------" + minOrderQuantity.toString());
                                                              if (minOrderQuantity != null && quantity != null) {
                                                                if (minOrderQuantity == quantity) {
                                                                  print("midsjnsjdj");
                                                                } else {
                                                                  print("Calling decreaseQuantity API because minOrderQuantity != quantity");
                                                                  decreaseQuantity(ncartlist[index]["addtoCartId"].toString());
                                                                  // Other function calls or logic can be placed here.
                                                                }
                                                              } else {
                                                                print("Either minOrderQuantity or quantity is null or not a valid integer");
                                                              }
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  04),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        1),
                                                              ]),
                                                          child: Icon(
                                                            EvaIcons.minus,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          ncartlist[index]
                                                                  ["quantity"]
                                                              .toString(),
                                                          //"02",
                                                          style: PricePrimaryTextStyle
                                                              .nameofTextStyle(),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          //   increaseQuantity(ncartlist[index]["addtoCartId"].toString());
                                                          setState(() {
                                                            increaseQuantity(
                                                                ncartlist[index]
                                                                        [
                                                                        "addtoCartId"]
                                                                    .toString());
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        1),
                                                              ]),
                                                          child: Icon(
                                                            EvaIcons.plus,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            isLoaded1
                                                ? FadeShimmer(
                                                    height: 10,
                                                    width: 100,
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "MOQ:" +
                                                              ncartlist[index][
                                                                  "minOrderQuantity"],
                                                          style: NormalPrimaryTextStyle
                                                              .nameofTextStyle()),
                                                      Text(
                                                          "MOQ:" +
                                                              ncartlist[index][
                                                                  "maxOrderQuantity"],
                                                          style: NormalPrimaryTextStyle
                                                              .nameofTextStyle()),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                      // Spacer(),
                                      isLoaded1
                                          ? FadeShimmer(
                                              height: 10,
                                              width: 100,
                                              baseColor: Colors.grey[400],
                                              highlightColor: Colors.grey[200],
                                            )
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      getAddtoCartRemoveItem(
                                                          ncartlist[index][
                                                                  "addtoCartId"]
                                                              .toString());
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      bottomNavigationBar: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Color(0xFF526FD8)),
                          height: deviceHeight * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///  Price Details
                                    Text(
                                      "\₹ ${totalPriceInt}",
                                      style: AddToCartButtonTextStyle
                                          .nameofTextStyle(),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 200,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Price Details',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Price'),
                                                            Text(
                                                                "\₹ ${TotalMrp}"),
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 2,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Discount '),
                                                            Text(
                                                                "\- ${TotalDiscountAmount}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 2,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Delivery Charges '),
                                                            Text(
                                                                "Free Delivery",
                                                                style: TextStyle(
                                                                    color: CupertinoColors
                                                                        .activeGreen)),
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 2,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Total Amount',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color:
                                                                      CupertinoColors
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                                "\₹ ${totalPriceInt}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: CupertinoColors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "View price details",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Address()));
                                    logoutDialogue();
                                  },
                                  child: Container(
                                    height: deviceHeight * 0.05,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    width: deviceWidth * 0.4,
                                    child: Center(
                                        child: Text(
                                      "Place order",
                                      style: ButtonTextStyle.nameofTextStyle(),
                                    )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  :

                  /// List is Empty:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: Image(
                            image: AssetImage("assets/empty-cart.png"),
                            height: deviceHeight * 0.50,
                            width: deviceWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 250),
                          child: Text(
                            "Your Cart is empty !",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: IconButton(
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
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String deliveryCharge = "";
  // String deliveryCharge ="";
  /* void DeliveryChargeAmount() {
    if(DeliveryCharges == "Free") {
      for (int i = 0; i < DeliveryCharges.length; i++) {
        print("dddddddddddddddddddddddddddddd");
        if (DeliveryCharges[i] == "Free") {
          deliveryCharge = "Free Delivery";
          print("ppppppppppppppppppppppp");
        } else {
          print("ggggggggggggggggggggg");
        }
      }
    } else {
      deliveryChargesList();
    }
    print("deliveryCharge---->>>>"+deliveryCharge);
  }*/

  void DeliveryChargeAmount() {
    if (DeliveryCharges.contains("Free")) {
      deliveryCharge = "Free Delivery";
      // deliveryChargesList();
      print("ppppppppppppppppppppppp");
    } else {
      print("qqqqqqqqqqqqqqqqqqqqqqqq123");
      deliveryChargesList(); // Assuming you have the implementation of this function.
    }
    print("deliveryCharge---->>>>$deliveryCharge");
  }

  /// DeliveryCharges
  List nDeliveryChargesList = [];
  void deliveryChargesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getDeliveryChargesList;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);

    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
        nDeliveryChargesList = mjson["data"];
      });

      var totalDeliveryCharge = 0;
      var lastValidDeliveryCharge = 0;
      for (var j = 0; j < mjson["data"].length; j++) {
        var MinimumPrice = int.parse(mjson["data"][j]["minPrice"]);
        var MaximumPrice = int.parse(mjson["data"][j]["maxPrice"]);
        var TotalDeliveryCharge = int.parse(mjson["data"][j]["totalCharges"]);

        if (totalPriceInt >= MinimumPrice && totalPriceInt <= MaximumPrice) {
          // Apply the delivery charge
          totalDeliveryCharge = TotalDeliveryCharge;
          break; // Exit the loop since the appropriate charge has been applied
        } else if (totalPriceInt > MaximumPrice) {
          // If total exceeds the highest MaximumPrice, use the last valid delivery charge
          lastValidDeliveryCharge = TotalDeliveryCharge;
          print("lastValidDeliveryCharge--->" +
              lastValidDeliveryCharge.toString());
          print("totalDeliveryCharge--->" + totalDeliveryCharge.toString());
        }
      }

      print("Delivery Charge---->" + lastValidDeliveryCharge.toString());
    } else {
      print('API Error');
    }
  }

  /// Logout AlertDialog Start Here
  logoutDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              content: new Text(
                  "We're working on the payment page now, and we'll get back to you soon.\n Visit www.lummng.com to browse a large selection of items."),
            ));
  }
}
