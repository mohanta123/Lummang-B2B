import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:my_store/pages/Category/category_list/sub_category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/urls/urls.dart';
import '../../../constants/utils/appbar.dart';
import 'package:http/http.dart' as http;

import '../../../functions/customStyle.dart';
import '../../my_cart.dart';
import '../../product/product_deatils.dart';
import '../../search.dart';
import '../../wishlist.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String productName;
  CategoryScreen(this.categoryId, this.productName);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _searchText = TextEditingController();
  @override

  ///simmer
  void initState() {
    super.initState();
    getOnlySubCategoryList();
    getOnlyCategoryList();
    getCartlist();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoaded = false;
      });
    });
  }

  bool isLoaded = true;

//  String productName ="";
  String categoryId = "";
  List ngetOnlySubCategory = [];
  void getOnlySubCategoryList() async {
    String api = getOnlySubCategoryListByParent + widget.categoryId;

    final response = await http.get(Uri.parse(api));
    //http.Response response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(widget.categoryId);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print(mjson);
      setState(() {
        ngetOnlySubCategory = mjson["data"];
      });
    } else {
      print('api Errors');
    }
  }

  List ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    print("6666666666666666666666666666666666666666666");
    print(prefs.getString("marketUsersId"));
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

  double TotalPercentage = 0;
  List totalPercentageInt = [];
  String CategoryId = "";
  List ngetOnlyCategory = [];
  void getOnlyCategoryList() async {
    String api = getProductListByCategory + widget.categoryId;
    final response = await http.get(Uri.parse(api));
    //http.Response response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(widget.categoryId);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print(mjson);
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
          widget.productName,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        itemCount: ngetOnlySubCategory.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubCategoryScreen(
                                          ngetOnlySubCategory[index]
                                                  ["categoryId"]
                                              .toString(),
                                          ngetOnlySubCategory[index]
                                                  ["categoryName"]
                                              .toString())));
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
                                          backgroundImage: NetworkImage(
                                              webBaseUrl +
                                                  ngetOnlySubCategory[index]
                                                      ['icon']),
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
                                              ngetOnlySubCategory[index]
                                                      ["categoryName"]
                                                  .toString(),
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

            // MensSubCategoryScreen(),
            SizedBox(height: deviceHeight * 0.010),

            // RecommendedProducts(),

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
                                          ngetOnlyCategory[index]
                                              ["productCoverImage"],
                                      fit: BoxFit.fill,
                                      width: 200,
                                      height: 190,
                                    ),
                                  ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
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
                                            ngetOnlyCategory[index]
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
                                          ngetOnlyCategory[index]["itemTitle"],
                                          //"(${products.offerText})",
                                    overflow: TextOverflow.ellipsis,
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
                                          /// Old Price
                                          Text(
                                            "\₹${ngetOnlyCategory[index]["mrp"]}",
                                            style: MrpPricePrimaryTextStyle
                                                .nameofTextStyle(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(width: 5.0),

                                          /// Price
                                          Text(
                                              "\₹${ngetOnlyCategory[index]["sellingPrice"]}",
                                              style: PricePrimaryTextStyle
                                                  .nameofTextStyle(),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis),
                                          SizedBox(width: 6.0),
                                          ///Percentage
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
                  );
                }),
          ],
        ),
      ),
    );
  }
}
