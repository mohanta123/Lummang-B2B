import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/urls/urls.dart';
import '../../../functions/customStyle.dart';
import '../../my_cart.dart';
import '../../product/product_deatils.dart';
import '../../search.dart';
import '../../wishlist.dart';
import '../products.dart';

class SubCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String CategoryName;
  SubCategoryScreen(this.categoryId, this.CategoryName);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  @override
  void initState() {
    super.initState();
    getProductSubCategory();
    getCartlist();
    getOnlyCategoryList();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoaded = false;
      });
    });
  }

  bool isLoaded = true;

  List ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId");
    final response = await http.get(Uri.parse(api));
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

  String categoryName = "";
  String categoryId = "";
  List getProductListSubCategory = [];
  void getProductSubCategory() async {
    String api = getOnlySubCategoryListByParent + widget.categoryId;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);

    // print(response.body);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      print(mjson);
      setState(() {
        getProductListSubCategory = mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  double TotalPercentage = 0;
  List totalPercentageInt = [];
  String CategoryId = "";
  List ngetOnlyCategory = [];
  void getOnlyCategoryList() async {
    String api = getProductListBySubCategory + widget.categoryId;
    final response = await http.get(Uri.parse(api));
    //http.Response response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(widget.categoryId);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print("wwwwwwwwwwwwwwwwwwwwwwwww" + mjson.toString());
      setState(() {
        ngetOnlyCategory = mjson["data"];
      });
      if (mjson["data"].length > 0) {
        double MrpDiscount = 0;
        double totalPrice = 0;
        double Percentage = 0;
        for (int i = 0; i < mjson["data"].length; i++) {
          /// Parse the sellingPrice and mrp after removing commas
          var sellingPriceString =
          mjson["data"][i]["sellingPrice"].toString().replaceAll(',', '');
          var mrpString =
          mjson["data"][i]["mrp"].toString().replaceAll(',', '');

          /// Convert the parsed strings to doubles
          var sellingPrice = double.parse(sellingPriceString);
          var mrp = double.parse(mrpString);

          /// Calculate the discount amount
          double discountAmount = mrp - sellingPrice;

          /// Calculate the discount percentage
          double discountPercentage = (discountAmount / mrp) * 100;

          Percentage = discountPercentage;
          TotalPercentage = Percentage;
          totalPercentageInt.add(TotalPercentage.toInt());

        }
      }
    } else {
      print('get api Errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.CategoryName,
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
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeInUp(
                delay: Duration(milliseconds: 45),
                child: Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: getProductListSubCategory.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewProducts(
                                          getProductListSubCategory[index]
                                                  ["categoryId"]
                                              .toString(),
                                          getProductListSubCategory[index]
                                                  ["categoryName"]
                                              .toString(),
                                        )));
                          },
                          child: Container(
                            width: 75,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                isLoaded
                                    ? FadeShimmer.round(
                                        size: 60,
                                        baseColor: Colors.grey[400],
                                        highlightColor: Colors.grey[200],
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        backgroundImage: NetworkImage( webBaseUrl+getProductListSubCategory[index]["icon"],
                                        ),
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  child: Container(
                                    height: deviceHeight * 0.05,
                                    width: deviceWidth * 0.19,
                                    child: isLoaded
                                        ? FadeShimmer(
                                            width: deviceWidth * 0.19,
                                            height: deviceHeight * 0.03,
                                            baseColor: Colors.grey[400],
                                            highlightColor: Colors.grey[200],
                                          )
                                        : Text(
                                            getProductListSubCategory[index]
                                                ["categoryName"],
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style:
                                                CategoryTitleNamePrimaryTextStyle
                                                    .nameofTextStyle(),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.010),
          GridView.builder(
              itemCount: ngetOnlyCategory.length,
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
                                ngetOnlyCategory[index]["sellerProductId"]
                                    .toString())));
                  },
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.grey
                    ),
                    child: Card(
                      child: Column(
                        children: [
                          /// Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: isLoaded
                                ? FadeShimmer(
                              width: 200,
                              height: 190,
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[200],
                            )
                                : Image.network(
                              imageBaseUrl +
                                  ngetOnlyCategory[index]["productCoverImage"],
                              fit: BoxFit.fill,
                              width: 200,
                              height: 190,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                /// Product Name
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 4.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: deviceHeight * 0.03,
                                    child:  isLoaded
                                        ? FadeShimmer(
                                      width: double.infinity,
                                      height: deviceHeight * 0.02,
                                      baseColor: Colors.grey[400],
                                      highlightColor: Colors.grey[200],
                                    )
                                        : Text(ngetOnlyCategory[index]["brandName"],
                                      // products.productTitle,
                                      style: PrimaryTextStyle.nameofTextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),

                               /// Product Name
                                Container(
                                  width: double.infinity,
                                  height: deviceHeight * 0.03,
                                  alignment: Alignment.topLeft,
                                  child: isLoaded
                                      ? FadeShimmer(
                                    width: double.infinity,
                                    height: deviceHeight * 0.02,
                                    baseColor: Colors.grey[400],
                                    highlightColor: Colors.grey[200],
                                  )
                                      : Text(
                                    ngetOnlyCategory[index]["itemTitle"],
                                    //"(${products.offerText})",
                                    style:
                                        TitlePrimaryTextStyle.nameofTextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                /// Product Details
                                isLoaded
                                    ? FadeShimmer(
                                  width: double.infinity,
                                  height: deviceHeight * 0.02,
                                  baseColor: Colors.grey[400],
                                  highlightColor: Colors.grey[200],
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Old Price
                                    Text(
                                      "\₹${ngetOnlyCategory[index]["mrp"]}",
                                      style: MrpPricePrimaryTextStyle
                                          .nameofTextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(width: 5.0),
                                    // Price
                                    Text(
                                        "\₹${ngetOnlyCategory[index]["sellingPrice"]}",
                                        style: PricePrimaryTextStyle
                                            .nameofTextStyle(),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis),
                                     SizedBox(width: 6.0),
                                    Text(
                                      totalPercentageInt[index]
                                          .toString() +
                                          "% off",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.green),
                                    ),
                                  ],
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
        ],
      ),
    );
  }
}

