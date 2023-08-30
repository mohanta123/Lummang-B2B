import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/product/product_deatils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/urls/urls.dart';
import '../functions/customStyle.dart';
import 'my_cart.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUserId");
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      //print(mjson);
      setState(() {
        ncartlist = mjson["data"];
      });
     // print(mjson);
    } else {
      print('api Error');
    }
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    AllSellerProducts();
  }
  final TextEditingController _searchText = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  List itemsOnSearch = [];
  // Searching Function for TextField
  onSearch(String search) {
    print(AllSellerProductListsData);
    setState(() {
      // itemsOnSearch = ndietlist;
      itemsOnSearch = AllSellerProductListsData
          .where((element) => element['itemTitle']
          .toString()
          .toLowerCase()
          .contains(search.toString().toLowerCase()))
          .toList();
    });
    print(itemsOnSearch);
  }

  List AllSellerProductListsData = [];
  void AllSellerProducts() async {
    String api = getAllSellerProductLists;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print(mjson);
      setState(() {
        AllSellerProductListsData = mjson["data"];
      });
    } else {
      print('api Error');
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    double deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: Color(0xFFD9EFF7),
           //backgroundColor: Color(0xFFEAE7FA),
        //  backgroundColor: Colors.white,
          elevation: 0.4,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF526FD8),
            ),
            onPressed: () {
              Navigator.of(context).pop();
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
           bottom: PreferredSize(
             child: SizedBox(
               height: 50,
               width: 350,
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 08),
                 child: TextFormField(
                   textAlign: TextAlign.start,
                   controller: _searchText,
                   onChanged: (value) {
                     onSearch(value);
                   },
                   decoration: InputDecoration(
                     filled: true,
                     fillColor: Colors.white,
                     prefixIcon: const Icon(
                       Icons.search,
                       color: Color(0xFF526FD8),
                     ),
                     suffixIcon: InkWell(
                       child: const Icon(
                           Icons.close,
                         color: Color(0xFF526FD8),
                       ),
                       onTap: () {
                         FocusManager.instance.primaryFocus?.unfocus();
                         setState(() {
                           itemsOnSearch = AllSellerProductListsData;
                         });
                         _searchText.clear();
                       },
                     ),
                     hintText: 'Search for products...',
                     contentPadding: const EdgeInsets.all(10),
                     border: const OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(15)),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(15),
                       borderSide:
                       BorderSide(color: Color(0xFF526FD8)),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(15),
                       borderSide:
                       BorderSide(color: Color(0xFF526FD8)),
                     ),
                   ),
                 ),
               ),
             ),
             preferredSize: Size.fromHeight(50),
           ),

        ),
        body: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                /// Main Item List For Searching
                Expanded(
                  child: AllSellerProductListsData.isEmpty
                      ? /// List is Empty:
                       Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: const Image(
                          image:
                          AssetImage("assets/search_fail.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 250),
                        child: const Text(
                          "No Result Found :(",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ),
                    ],
                  )
                 : itemsOnSearch.length > 0
                  /// List is Not Empty:
                 ? GridView.builder(
                      itemCount: itemsOnSearch.length,
                      physics: BouncingScrollPhysics(),
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
                                itemsOnSearch[index]["sellerProductId"]
                                    .toString())));
                          },
                          child: SingleChildScrollView(
                            child: Card(
                              child: Column(
                                children: [
                                  /// Product Images
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        imageBaseUrl +
                                            itemsOnSearch[index]
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
                                            child:Text(
                                              itemsOnSearch[index]
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
                                          child: Text(
                                            itemsOnSearch[index]["itemTitle"],
                                            //"(${products.offerText})",
                                            overflow: TextOverflow.ellipsis,
                                            style: TitlePrimaryTextStyle
                                                .nameofTextStyle(),
                                          ),
                                        ),

                                        /// Product Details
                                         Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            // Old Price
                                            Text(
                                              "\₹${itemsOnSearch[index]["mrp"]}",
                                              style: MrpPricePrimaryTextStyle
                                                  .nameofTextStyle(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(width: 5.0),

                                            /// Price
                                            Text(
                                                "\₹${itemsOnSearch[index]["sellingPrice"]}",
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
                          ),
                        );
                      }):
                  GridView.builder(
                      itemCount: AllSellerProductListsData.length,
                      physics: BouncingScrollPhysics(),
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
                                AllSellerProductListsData[index]["sellerProductId"]
                                    .toString())));
                          },
                          child: SingleChildScrollView(
                            child: Card(
                              child: Column(
                                children: [
                                  /// Product Images
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        imageBaseUrl +
                                            AllSellerProductListsData[index]
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
                                            child:Text(
                                              AllSellerProductListsData[index]
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
                                          child: Text(
                                            AllSellerProductListsData[index]["itemTitle"],
                                            //"(${products.offerText})",
                                            overflow: TextOverflow.ellipsis,
                                            style: TitlePrimaryTextStyle
                                                .nameofTextStyle(),
                                          ),
                                        ),

                                        /// Product Details
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            // Old Price
                                            Text(
                                              "\₹${AllSellerProductListsData[index]["mrp"]}",
                                              style: MrpPricePrimaryTextStyle
                                                  .nameofTextStyle(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(width: 5.0),

                                            /// Price
                                            Text(
                                                "\₹${AllSellerProductListsData[index]["sellingPrice"]}",
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
                          ),
                        );
                      })
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
