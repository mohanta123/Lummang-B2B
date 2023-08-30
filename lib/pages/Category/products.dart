import 'dart:convert';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/urls/urls.dart';
import '../../functions/customStyle.dart';
import '../../functions/localizations.dart';
import '../my_cart.dart';
import '../product/product_deatils.dart';
import '../wishlist.dart';

class ViewProducts extends StatefulWidget {
  final String categoryId;
  final String CategoryName;
  //final String SellerProductId;
  ViewProducts(this.categoryId,this.CategoryName,);

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  bool favourite = false;
  bool isAddedtoWishList = false;
  @override
  void initState() {
    super.initState();
    getProductListSubCategoryList();
    getCartlist();
    getsDetail();
    getWishlist();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoaded = false;
      });
    }
    );
  }

  bool isLoaded = true;
  List ncartlist=[];
  void getCartlist() async {
    setState(() {
      ncartlist=[];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId");
    final response = await http.get(Uri.parse(api));
    print("6666666666666666666666666666666666666666666");
    print(prefs.getString("marketUsersId"));
    print(response.statusCode);

    // print(response.body);
    if (response.statusCode == 200){

      var mjson = json.decode(response.body);
      //print(mjson);
      setState(() {
        ncartlist=mjson["data"];
      });
      print(mjson);
    } else {
      print('api Error');
    }
  }

  List<bool> _isFavorited = [];
  bool isButtonActive = true;

  String mobileNumber = "";
  String marketUsersId = "";
  void getsDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUsersId = prefs.getString("marketUsersId");
      mobileNumber = prefs.getString("mobileNumber");
    });
    print(prefs.getString("marketUsersId"));
  }

  ///add to wish list
  Future createWishlist(String sellerProductId) async {
    // SharedPreferences pref = await  SharedPreferences.getInstance();
    Map mjson;
    print(json.encode({
      'sellerProductId': sellerProductId,
      'marketUsersId': marketUsersId,
    }));
    http.post(Uri.parse(addWishList),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          'sellerProductId': sellerProductId,
          'createdBy': marketUsersId,
        }))
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        mjson = json.decode(response.body);
        getProductListSubCategoryList();
        showInSnackBar("Item Moved To Wishlist");
      } else {
        showInSnackBar("Item Removed To Wishlist");
      }
    }).catchError((onError) {
      print("error");
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  double TotalPercentage = 0;
  List totalPercentageInt = [];
  String categoryId ="";
  List getProductList=[];
  void getProductListSubCategoryList() async {
    String api = getProductListBySubCategoryList + widget.categoryId;
    print(widget.categoryId);
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200){
      var mjson = json.decode(response.body);
      print(mjson);
      setState(() {
        getProductList=mjson["data"];
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
      print('api Error');
    }

  }

  bool isLoading = false;
  Future<bool> addtoWishList(bool isLiked, int sellerProductId) async {
    setState(() {
      isLoading = true;
    });
    Map mjson;
    SharedPreferences preferences = await  SharedPreferences.getInstance();
    print(json.encode(
        {
          'sellerProductId': sellerProductId,
          'marketUsersId': preferences.getString("marketUsersId"),
        }));
    final http.Response response = await http.post(
      Uri.parse(addWishList),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "sellerProductId": sellerProductId.toString(),
        "marketUsersId":  preferences.getString("marketUsersId"),
      }),
    );

    if ("${response.statusCode}" == "200"){
      mjson = json.decode(response.body);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ProductsDetailsPage(sellerProductId.toString())));

    } else {
      print("errorrrrr");
    }
  }
  ///Removed the Wishlist
  void getRemoveItem(String myWishlistId) async {
    var nencoded = Uri.parse(deleteWishList + myWishlistId.toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        getProductListSubCategoryList();
        showInSnackBar("Item Removed From Wishlist");
      }
    });
  }

  int MyWishlistId = 0;
  List nwishlist = [];
  void getWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api =
        getMyWishlistListByMarketUser + prefs.getString("marketUsersId");
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      print("ttttttttttttttttttttt"+mjson.toString());
      setState(() {
        MyWishlistId = mjson["data"][0]["myWishlistId"];
        nwishlist = mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Colors.red,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => WishList()));
              }),
          IconButton(
            padding: EdgeInsets.only(right: 15),
            icon: FlutterBadge(
              icon: Icon(Icons.shopping_cart_outlined),
              borderRadius: 20.0,
              itemCount:
              ncartlist.length,
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
        child: GridView.builder(
            itemCount: getProductList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      ProductDetails(
                          getProductList[index]["sellerProductId"].toString()

                      )));
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
                          child:  isLoaded ?FadeShimmer(width:200,height: 190,
                            baseColor: Colors.grey[400],highlightColor: Colors.grey[200],):Image.network(
                            imageBaseUrl +  getProductList[index]["productCoverImage"],
                            fit: BoxFit.fill,
                            width:200,
                            height:190,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              /// Product Name
                              Container(
                               // alignment: Alignment.topLeft,
                                child:isLoaded ?FadeShimmer(width:double.infinity,height:  deviceHeight*0.03,
                                  baseColor: Colors.grey[400],highlightColor: Colors.grey[200],): Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getProductList[index]["brandName"],
                                      // products.productTitle,
                                      style: BrandNamePrimaryTextStyle.nameofTextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    /// Favorite
                                    Card(
                                        elevation: 2,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: isAddedtoWishList == false
                                              ? InkWell(
                                            onTap: () {
                                              createWishlist( getProductList[index]["sellerProductId"].toString());
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.favorite_outlined,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          )
                                              : InkWell(
                                            onTap: () {
                                              getRemoveItem(MyWishlistId.toString());
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.favorite_outlined,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 03,
                              ),
                              /// Product Name
                              isLoaded ?FadeShimmer(width:double.infinity,height:  deviceHeight*0.03,
                                baseColor: Colors.grey[400],highlightColor: Colors.grey[200],): Container(
                                height:deviceHeight*0.03 ,
                                width: double.
                                infinity,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  getProductList[index]["itemTitle"],
                                  //"(${products.offerText})",
                                  overflow: TextOverflow.ellipsis,
                                  style: TitlePrimaryTextStyle.nameofTextStyle(),
                                ),
                              ),
                              SizedBox(height: 05,),
                              /// Product Details
                              isLoaded ?FadeShimmer(width:double.infinity,height:  deviceHeight*0.03,
                                baseColor: Colors.grey[400],highlightColor: Colors.grey[200],): Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // Old Price
                                  Text(
                                    "\₹${getProductList[index]["mrp"]}",
                                    style: MrpPricePrimaryTextStyle.nameofTextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5.0),
                                  // Price
                                  Text(
                                      "\₹${getProductList[index]["sellingPrice"]}",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .color,
                                      ),
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
      ),
    );
  }
}



