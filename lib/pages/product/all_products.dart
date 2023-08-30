import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:my_store/pages/product/product_deatils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants/urls/urls.dart';
import '../../functions/customStyle.dart';
import '../my_cart.dart';
import '../search.dart';
import '../wishlist.dart';
import 'filter.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key key}) : super(key: key);

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  bool isLoaded = true;
  ///simmer
  void initState() {
    super.initState();
    getSellerProduct();
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
    String api = getAddtocartlist + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    print("6666666666666666666666666666666666666666666");
    print(prefs.getString("marketUserId"));
    print(response.statusCode);

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

  List nSellerProduct = [];
  void getSellerProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getSellerProductList;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      //print(mjson);
      setState(() {
        nSellerProduct = mjson["data"];
      });
      print(mjson);
    } else {
      print('api Error');
    }
  }
 int currentOption =1;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Products",style: AppbarPrimaryTextStyle.nameofTextStyle(),),
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
            itemCount: nSellerProduct.length,
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
                              nSellerProduct[index]["sellerProductId"]
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
                                nSellerProduct[index]
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
                                  nSellerProduct[index]
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
                                nSellerProduct[index]["itemTitle"],
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
                                  "\₹${nSellerProduct[index]["mrp"]}",
                                  style: MrpPricePrimaryTextStyle
                                      .nameofTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 5.0),

                                /// Price
                                Text(
                                    "\₹${nSellerProduct[index]["sellingPrice"]}",
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
      bottomNavigationBar: Container(
        height: 56,
        width: double.infinity,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///sort by
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SORT BY",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  RadioListTile(
                                    title: Text("Price Low to High"),
                                    value: 0,
                                    groupValue: currentOption,
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      setState(() {
                                        currentOption = val;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: Text("Whats New"),
                                    value: 1,
                                    groupValue: currentOption,
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      setState(() {
                                        currentOption = val;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: Text("Price High to Low"),
                                    value: 2,
                                    groupValue: currentOption,
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      setState(() {
                                        currentOption = val;
                                      });
                                    },
                                  ),

                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                child: Container(
                  width: 100,
                  height: double.infinity,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward),
                      Text(
                        "SORT BY",
                        style: TextStyle(),
                      )
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 2,
              ),

              ///category
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return SizedBox(
                              height: 230,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "CATEGORY",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("MEN"),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("WOMEN"),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black, width: 1),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          height: 50,
                                          width: 150,
                                          child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(color:Colors.black,
                                              border: Border.all(
                                                  color: Colors.black, width: 1),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          height: 50,
                                          width: 220,
                                          child: Center(
                                              child: Text(
                                                "Apply Filter",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                                  // RadioListTile<Fruit>(
                                  //   title: const Text('Apple'),
                                  //   activeColor: Colors.green,
                                  //   value: Fruit.apple,
                                  //   groupValue: _fruit,
                                  //   onChanged: (Fruit? value) {
                                  //     setState(() {
                                  //       _fruit = value;
                                  //     });
                                  //   },
                                  // ),
                                  // RadioListTile<Fruit>(
                                  //   title: const Text('Banana'),
                                  //   value: Fruit.banana,
                                  //   activeColor: Colors.green,
                                  //   groupValue: _fruit,
                                  //   onChanged: (Fruit? value) {
                                  //     setState(() {
                                  //       _fruit = value;
                                  //     });
                                  //   },
                                  // ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                child: Container(
                  width: 100,
                  height: double.infinity,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward_outlined),
                      Text(
                        "CATEGORY",
                        style: TextStyle(),
                      )
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 2,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Filterr()));
                },
                child: Container(
                  width: 100,
                  height: double.infinity,
                  child: Row(
                    children: [
                      Icon(Icons.sort_outlined),
                      Text(
                        "FILTER",
                        style: TextStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
