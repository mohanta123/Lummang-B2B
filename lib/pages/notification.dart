import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_badged/flutter_badge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_store/constants/utils/appbar.dart';
import 'package:my_store/constants/utils/custom_color.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls/urls.dart';
import 'my_cart.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  void initState() {
    super.initState();
    getCartlist();
    // _timer = Timer.periodic(Duration(seconds: refreshIntervalInSeconds), (Timer timer)
    // {
    //   getCartlist();
    // });
    getBuyerNotifications();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  // Timer _timer;
  // int refreshIntervalInSeconds = 3;
  List<dynamic> ncartlist = [];
  void getCartlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getAddtocartlist + prefs.getString("marketUsersId").toString();
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

  List notificationLists=[];
  void getBuyerNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api = getBuyerNotification + prefs.getString("marketUsersId").toString();
    final response = await http.get(Uri.parse(api));
    print(prefs.getString("marketUsersId"));
    print(response.statusCode);

    // print(response.body);
    if (response.statusCode == 200){
      var mjson = json.decode(response.body);
      //print(mjson);
      setState(() {
        notificationLists=mjson["data"];
      });
    } else {
      print('api Error');
    }
  }

  int notification = 2;
  final notificationList = [
    {
      'title': 'Biggest Offers on Men\'s Fashion!',
      'description':
          'Bestselling Men\'s Fashion Products at Lowest Prices. Avail 10% Instant Discount* on HDFC Cards. Only till June 5th!'
    },
    {
      'title': 'Biggest Sale Of The Year!',
      'description':
          'Biggest Sale of the year started now only on MyCart. Browse product and start shopping now. Hurry!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: PrimaryAppBar.nameofAppBar(context),
      appBar: AppBar(
        title: Text(
          "Notification",
          style: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            letterSpacing: 1.7,
          ),
        ),
        titleSpacing: 10.0,
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
      body: notificationLists.isEmpty
          ?  Column(
        children: [
          SizedBox(
            height: size.height * 0.10,
          ),
          Center(
            child: Image(
              image: AssetImage("assets/Notificaton.png"),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            "Your Notfication is empty right now :(",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16),
          ),
          IconButton(
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
            ),
          ),
        ],
      )
      /*(notification == 0)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.bellSlash,
                    color: Colors.grey,
                    size: 60.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('notification', 'noNotificationsString'),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            )*/
          : ListView.builder(
              itemCount: notificationLists.length,
              itemBuilder: (context, index) {
                final item = notificationLists[index];
                return Container(
                  //  color: PrimaryColor.withOpacity(0.5),
                    child: Card(
                      elevation: 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              backgroundColor: PrimaryColor,
                              child: Icon(
                                FontAwesomeIcons.bell,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              radius: 40.0,
                            ),
                          ),
                          Container(
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 4.0,
                                      right: 8.0,
                                      left: 8.0,
                                  ),
                                  child: Text(notificationLists[index]["title"].toString(),
                                   // '${item['title']}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.7,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      right: 8.0,
                                      left: 8.0,
                                      bottom: 8.0),
                                  child: Text(notificationLists[index]["massage"].toString(),
                                   // '${item['description']}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      height: 1.6,
                                      color: Colors.grey,
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
              },
            ),
    );
  }
}
