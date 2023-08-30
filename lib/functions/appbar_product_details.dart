import 'dart:async';
import 'dart:convert';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/urls/urls.dart';
import '../pages/my_cart.dart';
import '../pages/wishlist.dart';
import 'customStyle.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {


  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    getCartlist();
    _timer = Timer.periodic(Duration(seconds: refreshIntervalInSeconds), (_) {
      getCartlist();
   });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  Timer _timer;
  int refreshIntervalInSeconds = 3;
  List<dynamic> ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      if (mounted) { /// Check if the widget is still mounted
        setState(() {
          ncartlist = mjson["data"];
        });
      }
     /// print(mjson);
    } else {
      print('fdghjkljjgfghjapi Error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
