import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

// My Own Import
import 'package:my_store/pages/home/home_component/deal_of_the_day.dart';
import 'package:my_store/pages/home/home_component/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/urls/urls.dart';
import 'package:http/http.dart' as http;
import '../../order_page/my_order.dart';
import '../Category/category_list/subscriptionsId_products_lists.dart';
import '../call_center/call_center.dart';
import '../login_signup/mobile_number_screen.dart';
import '../my_cart.dart';
import '../product/all_products.dart';
import '../product/product_deatils.dart';
import '../search.dart';
import '../wishlist.dart';
import 'home_component/main_slider.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  bool isAvalable = false;

  /// Subscription Type List
  List SubscriptionTypeList = [];
  List jSubscriptionTypeList = [];
  void gSubscriptionTypeList() async {
    String api = getSubscriptionTypeList;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
    if (response.statusCode == 200) {
      Map nmjson = json.decode(response.body);
      setState(() {
        SubscriptionTypeList = nmjson["data"];
      });
      productListBySubscription();
    } else {
      print('api Error Type SubscriptionTypeList');
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
        String nSubscriptionTypeId = "";
        for (int j = 0; j < productsListBySubscription.length; j++) {
          if (SubscriptionTypeList[i]["subscriptionTypeId"].toString() ==
              productsListBySubscription[j]["subscriptionTypeId"].toString()) {
            ntproducts.add(productsListBySubscription[j]);
            nSubscriptionTypeId=(SubscriptionTypeList[i]["subscriptionTypeId"].toString());
          }
        }
        if (ntproducts.length > 0) {
          setState(() {
            jSubscriptionTypeList.add({
              "TypeName": SubscriptionTypeList[i]["subscriptionName"].toString(),
              "Products": ntproducts,
              "typeId": nSubscriptionTypeId
            });
          });
        }
      }
      print(
          "--------------------------------------------------------------------------");
    } else {
      print('api Error by productListBySubscription');
    }
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    AllSellerProducts();
    getsHomePageBannerLists();
    getSellerProduct();
    gSubscriptionTypeList();
    getBuyerDetails();
    getDetails();
   // getCartlist();
    // _timer = Timer.periodic(Duration(seconds: refreshIntervalInSeconds), (Timer timer)
    // {
    //   getCartlist();
    // });
  }

  String mobileNumber = "";
  String marketUserId = "";
  String ShopOwnerName = "";
  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = prefs.getString("marketUsersId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
      ShopOwnerName = prefs.getString("ShopOwnerName").toString();
    });
  }

 // List nBuyerDetails = [];
  String ShopName = "";
  void getBuyerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getBuyerKYCListByMarketUserId + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
       // nBuyerDetails = mjson["data"];
        ShopName = mjson["data"]["shopeName"].toString();
      });
      print(mjson);
    } else {
      print('api Error BuyerDetails');
    }
  }

int _currentPage=0;
 // List<dynamic> imageList = [];

 //  void initializeImageList() {
 //    imageList = List.generate(4, (index) => HomePageBannerList[0]["banner"]);
 //  }
    List HomePageBannerList = [];
  List imageList = [];
  void getsHomePageBannerLists() async {
    String api = getHomePageBannerLists;
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      setState(() {
        HomePageBannerList = mjson["data"];
        imageList.add(mjson["data"][0]["banner"]);
        imageList.add(mjson["data"][1]["banner"]);
        imageList.add(mjson["data"][2]["banner"]);
        imageList.add(mjson["data"][3]["banner"]);
      });
    } else {
      print('api Error HomePageBannerLists');
    }
  }


   // Timer _timer;
   //  int refreshIntervalInSeconds = 3;
  List nncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUserId").toString();
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      if (mounted) {
        setState(() {
          nncartlist = mjson["data"];
        });
      }
    } else {
      print('api Error Cartlist');
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  /// Create key
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    /// Logout AlertDialog Start Here
    logoutDialogue() {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: new Text("Confirmation"),
                content: new Text("Do you want to logout?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Yes", style: TextStyle(color: Colors.black)),
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();

                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => MobileScreen()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("Exit", style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    }

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        key: _key,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                arrowColor: Color(0xFF526FD8),
                accountEmail: Text(mobileNumber),
                accountName: Text(ShopName),
                currentAccountPicture: ProfilePicture(
                  name: ShopName,
                  radius: 31,
                  fontsize: 26,
                  random: true,
                ),
              ),

              ListTile(
                title: const Text('My Profile'),
                leading: Icon(EvaIcons.person),
                //leading: EdgeInsets.only(left: 60),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              /// Your Order
              ListTile(
                title: Text("Your Order"),
                leading: Icon(
                  EvaIcons.cubeOutline,
                  size: 26,
                ),
                //leading: EdgeInsets.only(left: 60),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MYOrderPage()));
                  //Navigator.pop(context);
                },
              ),

              /// Wishlist
              ListTile(
                title: Text("Wishlist"),
                leading: Icon(
                  EvaIcons.heartOutline,
                  size: 26,
                ),
                //leading: EdgeInsets.only(left: 60),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WishList()));
                  //  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Help Center"),
                leading: Icon(
                  EvaIcons.questionMarkCircleOutline,
                  size: 26,
                ),
                //leading: EdgeInsets.only(left: 60),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CallCenter()));
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                leading: Icon(EvaIcons.logInOutline),
                //leading: EdgeInsets.only(left: 60),
                onTap: () {
                  logoutDialogue();
                },
              ),
              /* ExpansionTile(
                title: Text("Women's"),
                leading: Icon(Icons.person),
                childrenPadding: EdgeInsets.only(left: 60),
              ),*/
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.4,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF526FD8),
            ),
            onPressed: () {
              _key.currentState.openDrawer();
            },
          ),
          title: Image.asset(
            "assets/Logo_Latter.png",
            height: 15,
          ),
          titleSpacing: 0.0,
          centerTitle: true,
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
              padding: EdgeInsets.only(right: 15),
              icon: FlutterBadge(
                icon: Icon(Icons.shopping_cart_outlined),
                borderRadius: 20.0,
                itemCount: nncartlist.length,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyCart()));
              },
            ),
          ],
        ),
        // appBar: PrimaryAppBar.nameofAppBar(context),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               MainSlider(),
              SizedBox(
                height: deviceHeight * 0.005,
              ),
              HomeCategoryMenu(),
              SizedBox(
                height: deviceHeight * 0,
              ),

              /// Featured Item Start
             // DealOfTheDay(),
              SizedBox(
                height: 4.0,
              ),

              ///new arrival, hot deals ,top brand
              ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: jSubscriptionTypeList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 09),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              jSubscriptionTypeList[index]["TypeName"]
                                  .toString(),
                              // "Hot Deals of the Day",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubscriptionProductsLists(
                                         // jSubscriptionTypeList[index]["Products"][index]["subscriptiontTypeId"].toString(),
                                          jSubscriptionTypeList[index]["typeId"].toString(),
                                          jSubscriptionTypeList[index]["TypeName"].toString(),)));
                              },
                              child: Container(
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF526FD8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // ScrollViewProducts(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            //  color: Colors.yellow,
                            height: deviceHeight * 0.33,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: jSubscriptionTypeList[index]
                                        ["Products"]
                                    .length,
                                shrinkWrap: true,
                                itemBuilder: (context, nindex) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      /* Padding(
                                        padding: EdgeInsets.only(left: 10, right: 10, top: 09),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              jSubscriptionTypeList[index]["Products"][nindex]
                                              ["subscriptionName"].toString(),
                                              // jSubscriptionTypeList[index]["TypeName"].toString(),
                                              // "Hot Deals of the Day",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                "See All",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF526FD8)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),*/
                                      Card(
                                       // elevation: 10,
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ProductDetails(
                                                          jSubscriptionTypeList[index]["Products"][nindex]["sellerProductId"]
                                                              .toString(),
                                                        )));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15),
                                                  ),
                                                ),
                                                child: Container(
                                                  width: deviceWidth * 0.45,
                                                  height: deviceHeight * 0.25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Center(
                                                      child: Image.network(
                                                          imageBaseUrl +
                                                              jSubscriptionTypeList[index]["Products"][nindex]["productCoverImage"]
                                                                  .toString(),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  jSubscriptionTypeList[index]
                                                                  ["Products"]
                                                              [nindex]
                                                          ["itemTitle"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
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
              ),
            ])),
      ),
    );
  }

  List AllSellerProductListsData = [];
  List SearchAllSellerProductListsData = [];
  void AllSellerProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAllSellerProductLists;
    final response = await http.get(Uri.parse(api));
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
     // print(mjson);
      setState(() {
        AllSellerProductListsData = mjson["data"];
      });
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
     // print(mjson);
    } else {
      print('api Error');
    }
  }
}

Widget buildIndicator() {
  List imageList=[];
  int _currentPage=0;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: imageList.map((image) {
      int newIndex = imageList.indexOf(image); // Rename the variable
      return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == newIndex ? Colors.blue : Colors.grey,
        ),
      );
    }).toList(),
  );
}

