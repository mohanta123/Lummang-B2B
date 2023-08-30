import 'dart:async';
import 'dart:convert';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/urls/urls.dart';
import '../../functions/appbar_product_details.dart';
import '../../functions/customStyle.dart';

class ProductDetails extends StatefulWidget {
  final String sellerProductId;
  const ProductDetails(this.sellerProductId, {Key key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDeatilsState();
}

///change notifier

class _ProductDeatilsState extends State<ProductDetails> {


  bool isAddedToCart = false;

  List<int> selectedIndex = [];
  int selectedSize = 3;
  int selectedColor = 0;

  List imageList = [];
  List<String> toarray = [];

  bool isFavorite = false;

  final CarouselController carouselController = CarouselController();
  int _value = 1;

  int currentSlider = 0;

  @override
  void initState() {
    super.initState();
    getsDetail();
    getSingleSellerProductDetails();
    getWishlist();
   // similarProductList();
   // SimilarproductCalculation();
  }
bool isLoaded=true;
  /// Local Data Storage
  String mobileNumber = "";
  String marketUsersId = "";
  void getsDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUsersId = prefs.getString("marketUsersId").toString();
      mobileNumber = prefs.getString("mobileNumber").toString();
    });
    print("---------------------------"+marketUsersId);
  }

  ///item size
bool _isPanel1Expanded=false;
  String categoryId = "";
  List image = [];
  List<Widget> images = [];
  String itemTitle = "";
  String brandName = "";
  String designCode = "";
  String sellType = "";
  String mrp = "";
  String subCategoryId = "";
  String SellingPrice = "";
  String productImage1 = "";
  String productImage2 = "";
  String productImage3 = "";
  String productImage4 = "";
  List getProductDetails = [];
  String productDescription = "";
  String maincategoryname = "";
  String sellerProductId = "";

  int MinusSellingPrice =0;


  int intSellingPrice=0;
  int sellingAmountPrice=0;
  String a = '';
  String SizeColor = '';
  String filtersValueName = '';
  String minOrderQuantity = '';
  String filtersName = '';
  double Percentage = 0;
  double TotalPercentage = 0;
  int totalPercentageInt = 0;
  int currentPage = 1;
  List<dynamic> orderData = [];
  int filterName = 0;
  int filterValueName = 0;
  void getSingleSellerProductDetails() async {
    String api = getSingleSellerProduct + widget.sellerProductId;
    print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO" + widget.sellerProductId);
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
        itemTitle = mjson["data"]["itemTitle"];
        brandName = mjson["data"]["brandName"];
        designCode = mjson["data"]["designCode"];
        sellType = mjson["data"]["sellType"];
        mrp = mjson["data"]["mrp"];
        SellingPrice = mjson["data"]["sellingPrice"].toString();
        subCategoryId = mjson["data"]["subCategoryId"].toString();
        sellerProductId = mjson["data"]["sellerProductId"].toString();
        productDescription = mjson["data"]["productDescription"].toString();
        maincategoryname = mjson["data"]["maincategoryname"].toString();
        minOrderQuantity = mjson["data"]["minOrderQuantity"].toString();
        imageList.add(mjson["data"]["productImage1"]);
        imageList.add(mjson["data"]["productImage2"]);
        imageList.add(mjson["data"]["productImage3"]);
        imageList.add(mjson["data"]["productImage4"]);

sellingAmountPrice=int.parse(SellingPrice);
print("xxxxxxxxxxxxxxxxxx==="+sellingAmountPrice.toString());
        SimilarproductCalculation(sellingAmountPrice);
    /// Access the filterTableViewDTO property correctly
        var filterTableViewDTO = mjson["filterTableViewDTO"];
        List filters = [];
        for (int i = 0; i < filterTableViewDTO.length; i++) {
          bool isExists = false;
          for (int j = 0; j < filters.length; j++) {
            if (filters[j]['filterName'] ==
                filterTableViewDTO[i]['filterName']) {
              isExists = true;
              break;
            }
          }
          if (!isExists) {
            filters.add(filterTableViewDTO[i]);
          }
        }
        String a = "";
        String b = "";
        for (int i = 0; i < filters.length; i++) {
          a += filters[i]["filterName"] +
              ": "; // Append filterName to the result string
          for (int j = 0; j < filterTableViewDTO.length; j++) {
            if (filters[i]['filterId'] == filterTableViewDTO[j]['filterId']) {
              b += filterTableViewDTO[j]["filterValueName"]  ; // Append filterValueName to the result string
            }
          }
          /// Remove the extra ", " from the end of the string
          if (a.endsWith(", ")) {
            a = a.substring(0, a.length - 2);
          }
          a += "\n";
          /// Add a new line after each filterName and its filterValueNames
          b += "\n";
        }
        filtersName = a;
        filtersValueName = b;
      });
      if (mjson["data"].length > 0) {
        /// Parse the sellingPrice and mrp after removing commas
        var sellingPriceString =
            mjson["data"]["sellingPrice"].toString().replaceAll(',', '');
        var mrpString = mjson["data"]["mrp"].toString().replaceAll(',', '');

        /// Convert the parsed strings to doubles
        var sellingPrice = double.parse(sellingPriceString);
        var mrp = double.parse(mrpString);

        /// Calculate the discount amount
        double discountAmount = mrp - sellingPrice;

        /// Calculate the discount percentage
        double discountPercentage = (discountAmount / mrp) * 100;

        Percentage = discountPercentage;
        TotalPercentage = Percentage;
        totalPercentageInt = TotalPercentage.toInt();
      }
    } else {
      print('api Error');
    }
  }
//int price =0;
  int minusSellingPrice =0;
  int plusSellingPrice =0;
  int PlusSellingPrice =0;
  void SimilarproductCalculation(int sellingAmountPrice){
    var sellingPrice = sellingAmountPrice; /// Example value, replace with your actual numeric value
    var intSellingPrice = "100"; /// Example value, replace with your actual string value
    /// Convert intSellingPrice to an integer before performing the addition
    var integerSellingPrice = int.parse(intSellingPrice);

    /// Calculate PlusSellingPrice
    var plusSellingPrice = sellingPrice + integerSellingPrice;
    PlusSellingPrice= plusSellingPrice;
    print("plusSellingPrice=="+plusSellingPrice.toString()); // This will print the result of the addition

    /// Calculate MinusSellingPrice
    var minusSellingPrice = sellingPrice - integerSellingPrice;
    MinusSellingPrice= minusSellingPrice;
    similarProductList(MinusSellingPrice);
    print("minusSellingPrice=="+minusSellingPrice.toString()); /// This will print the result of the subtraction
  }

  bool isAddedtoWishList = false;

  ///Add to Wishlist
  String MyWishlistId ="";
  Future createWishlist(String sellerProductId) async {
   print("nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    Map mjson;
    print(json.encode({
      'sellerProductId': sellerProductId,
      'marketUsersId': marketUsersId,
    }));
    http
        .post(Uri.parse(addWishList),
            headers: {"content-type": "application/json"},
            body: jsonEncode({
              'sellerProductId': sellerProductId,
              'createdBy': marketUsersId.toString(),
            }))
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        mjson = json.decode(response.body);
        MyWishlistId = mjson["myWishlistId"].toString();
        setState(() {
          isAddedtoWishList = true;
        });
        getSingleSellerProductDetails();
        showInSnackBar("Item Moved To Wishlist");
      } else {
        showInSnackBar("Already Available Product Wishlist");
      }
    }).catchError((onError) {
      print("error");
    });
  }

  ///Removed the Wishlist
  void getRemoveItem(String myWishlistId) async {
    var nencoded = Uri.parse(deleteWishList + myWishlistId.toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        getWishlist();
        showInSnackBar("Item Removed From Wishlist");
      }
    });
  }

  List nwishlist = [];
  void getWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getMyWishlistListByMarketUser + prefs.getString("marketUsersId");
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeee--"+mjson.toString());
      setState(() {
        nwishlist = mjson["data"];
      });
print(MyWishlistId);
    } else {
      print('api Error');
    }
  }



  /// item move to Cart
  Future moveToCart(String sellerProductId) async {
    Map mjson;
    print(json.encode({
      'sellerProductId': sellerProductId.toString(),
      'createdBy': marketUsersId.toString(),
      'quantity': minOrderQuantity.toString()
    }));
    http
        .post(Uri.parse(itemAddtoCart),
            headers: {"content-type": "application/json"},
            body: jsonEncode({
              'sellerProductId': sellerProductId.toString(),
              'createdBy': marketUsersId.toString(),
              'quantity': minOrderQuantity.toString()
            }))
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        mjson = json.decode(response.body);
        // getWishlist();
        showInSnackBar("Item Moved To Cart");
      } else {
        showInSnackBar("Item already added in cart");
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
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      /* AppBar(
        //  backgroundColor: Color(0xFFD7F8E2),
        title: Text(
          "Product Details",
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
          ),
        ],
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Color(0xFF526FD8),
        //   ),
        //   onPressed: () {
        //     // Navigator.push(context,
        //     //     MaterialPageRoute(builder: (context) => OrderDetails()));
        //   },
        // ),
      ),*/
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.red,
                width: deviceWidth,
                child: CarouselSlider(
                  options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      // autoPlay: true,
                      height: 300.0,
                      aspectRatio: 1.3,
                      autoPlayInterval: Duration(seconds: 10),
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentSlider = index;
                        });
                      }),
                  items: [
                    for (int i = 0; i < imageList.length; i++)
                      Container(
                        margin: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image:
                            NetworkImage(imageBaseUrl + imageList[i]),
                            //  image: NetworkImage(productImage1[i]),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                  ],
                  carouselController: carouselController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageList.asMap().entries.map(
                      (entry) {
                    print(entry);
                    print(entry.key);
                    return GestureDetector(
                      onTap: () =>
                          carouselController.animateToPage(entry.key),
                      child: Container(
                        width: currentSlider == entry.key ? 17 : 7,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 3.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentSlider == entry.key
                                ? Colors.red
                                : Colors.teal),
                      ),
                    );
                  },
                ).toList(),
              ),

              /// Details
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  Text(
                    brandName,
                    style: TextStyle(color: Colors.indigo, fontSize: 18),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$itemTitle",
                          // "Product Title",
                          style:
                          TitleNamePrimaryTextStyle.nameofTextStyle(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    height: 70,
                    width: 400,
                    color: Colors.green.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Special Wholesale Price",
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 15)),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              ///Percentage
                              Text(
                                totalPercentageInt.toString() + "% off",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                mrp,
                                style: MrpPricePrimaryTextStyle
                                    .nameofTextStyle(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                //widget.mrp,
                                "\ ₹${SellingPrice}",
                                style: PricePrimaryTextStyle
                                    .nameofTextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            //filterName.toString(),
                            filtersName+" ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.indigo),
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                            child: Text(
                              //filterName.toString(),
                              " "+filtersValueName+" ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ExpansionTile(

                    title: Text('Product Deatials',style: TextStyle(
                        color: Colors.indigo
                    ),),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isPanel1Expanded = expanded;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child:Container(
                          child:  Column(
                            children: [
                              Text(
                                productDescription,
                                style: ProductPrimaryTextStyle.nameofTextStyle(),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Category : "),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    maincategoryname,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              /* Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Item Title : "),
                        SizedBox(width: 10,),
                        Expanded(child: Text(itemTitle, style: TextStyle(fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ),*/
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Brand Name : "),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    brandName,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Design Code : "),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    designCode,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("SellType : "),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    sellType,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ///product details


                ],
              ),
              Divider(
                thickness: 2,
              ),
              Text("Similar Products"
                ,style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo
                ),),
              ///similar product
              SizedBox(
                height: 100,
                width: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:nSimilarProductList.length ,
                    itemBuilder: (context,index){return
                      Card(
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
                                      nSimilarProductList[index]
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
                                        nSimilarProductList[index]
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
                                      nSimilarProductList[index]["itemTitle"],
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
                                      /// Old Price
                                      Text(
                                        "\₹${nSimilarProductList[index]["mrp"]}",
                                        style: MrpPricePrimaryTextStyle
                                            .nameofTextStyle(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(width: 5.0),

                                      /// Price
                                      Text(
                                          "\₹${nSimilarProductList[index]["sellingPrice"]}",
                                          style: PricePrimaryTextStyle
                                              .nameofTextStyle(),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis),
                                      SizedBox(width: 6.0),
                                      ///Percentage

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );}),
              )
            ],
          ),
        ),
      ),

      ///bottom navigation bar
      bottomNavigationBar: Container (
        height: deviceHeight * 0.07,
        child: Row(
          children: [
            Container(
              width: deviceWidth * 0.2,
              height: deviceHeight * 0.8,
              color: Colors.white,
              child:  isAddedtoWishList == false
                  ? GestureDetector(
                onTap: () {
                  print('Add to wishlist tapped');
                  createWishlist(sellerProductId.toString());
                },
                child: Icon(
                  Icons.favorite_outlined,
                  color: Colors.grey[500],
                  size: 40,
                ),
              )
                  : GestureDetector(
                onTap: () {
                  getRemoveItem(MyWishlistId.toString());
                },
                child: Icon(
                  Icons.favorite_outlined,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                moveToCart(sellerProductId.toString());
              },
              child: Container(
                width: deviceWidth * 0.4,
                color: Color(0xFF526FD8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Add To Cart",
                        style: AddToCartButtonTextStyle.nameofTextStyle())
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                /*  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Address()));*/
                logoutDialogue();
              },
              child: Container(
                width: deviceWidth * 0.4,
                alignment: Alignment.center,
                color: Colors.red,
                child: Text("Buy Now",
                    style: AddToCartButtonTextStyle.nameofTextStyle()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List nSimilarProductList = [];
  void similarProductList(int minusSellingPrice) async {
    String api = getSimilarProductList+"/"+subCategoryId+"/"+PlusSellingPrice.toString()+"/"+minusSellingPrice.toString();
    print(api);
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      setState(() {
        nSimilarProductList = mjson["data"];
      });
      print("++++++++++++++++++++++++++++++++++"+mjson.toString());
    } else {
      print('apppi Error');
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
