import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/urls/urls.dart';
import '../../my_cart.dart';
import '../../product/product_deatils.dart';
import '../../wishlist.dart';

class Category extends StatefulWidget {
  final String categoryName;
  const Category({Key key, @required this.categoryName}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    super.initState();
    parentCategorylist();
    getCartlist();
    // _timer = Timer.periodic(Duration(seconds: refreshIntervalInSeconds), (Timer timer)
    // {
    //   getCartlist();
    // });
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  // Timer _timer;
  // int refreshIntervalInSeconds = 3;
  List<dynamic> ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUserId");
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

  List getParentCategorylist = [];
  void parentCategorylist() async {
    String api = getParentCategoryList;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      setState(() {
        getParentCategorylist = mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  String categoryId = "";
  List ngetOnlySubCategory = [];
  void getOnlySubCategoryList(String categoryId) async {
    String api = getOnlySubCategoryListByParent + categoryId;
    final response = await http.get(Uri.parse(api));
    //http.Response response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(categoryId);
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

  List<String> items = [
    "Home",
    "Explore",
    "Search",
    "Feed",
    "Post",
    "Activity",
    "Setting",
    "Profile",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.home,
    Icons.explore,
    Icons.search,
    Icons.feed,
    Icons.post_add,
    Icons.local_activity,
    Icons.settings,
    Icons.person
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: false,
        /* leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF526FD8),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),*/
        title: Text(
          "Shop by Categories",
          style: GoogleFonts.roboto(
              fontSize: 20,
              color: Color(0xFF526FD8),
              fontWeight: FontWeight.bold),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CUSTOM TAB BAR
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: getParentCategorylist.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                            getOnlySubCategoryList(getParentCategorylist[index]
                                    ["categoryId"]
                                .toString());
                            // getOnlySubCategoryList(current.toString());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 80,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.circular(10),
                              border: current == index
                                  ? Border.all(
                                      color: Colors.deepPurpleAccent, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                getParentCategorylist[index]["categoryName"],
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: current == index,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  shape: BoxShape.circle),
                            ))
                      ],
                    );
                  }),
            ),
            /*  Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i=1;i<8;i++)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: BoxDecoration(
                         // color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.blueAccent,width: 2)
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //user i variable to change pictures
                            Text("Women",
                              style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                ),

              ),
            ),*/
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Categories",
                style:  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              thickness: 2,
            ),

            /// Product ViewList
            GridView.builder(
                itemCount: ngetOnlySubCategory.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //    MaterialPageRoute(builder: (context) => ProductDetails(ngetOnlySubCategory[index]["sellerProductId"].toString())));
                    },

                    child: Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.grey
                      ),
                      child: Column(
                        children: [
                          /// Product Image
                          Card(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                webBaseUrl+ ngetOnlySubCategory[index]["icon"],
                                //"assets/13.jpg",
                                fit: BoxFit.fill,
                                width: 200,
                                height: 120,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Product Name
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    ngetOnlySubCategory[index]["categoryName"],
                                    // products.productTitle,
                                    style:  GoogleFonts.roboto(fontSize: 15.0,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,),

                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
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
