import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:my_store/constants/utils/custom_color.dart';

import '../../pages/my_cart.dart';
import '../../pages/search.dart';

// Used In product appbar
class ProductSubCategoryAppBar {
  static AppBar nameofAppBar(BuildContext context) => AppBar(
        elevation: 0.4,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Color(0xFF526FD8),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 30,
        title: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Image.asset(
              "assets/appbar_logo.png",
              height: 30,
            )),
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF526FD8),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }),
          IconButton(
            padding: EdgeInsets.only(right: 15),
            // icon: Badge(badgeContent: Text('2',
            //   style: TextStyle(color: Colors.white),
            // ),
            // badgeColor: Colors.green,
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF526FD8),
            ),

            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
          ),
        ],
      );
}

/*class ProductSubCategoryAppBar {
  static AppBar nameofAppBar() =>  AppBar(
    automaticallyImplyLeading: false,
    elevation: 0.4,
    title: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          "assets/lummang_logo.png",
          height: 30,
        )
    ),
    titleSpacing: 0.0,
    actions: <Widget>[
      IconButton(
        icon: Badge(
          badgeContent: Text('2',
            style: TextStyle(color: Colors.white),
          ),
          badgeColor: Colors.red,
          child: Icon(Icons.notifications_rounded,
            color: Colors.blue,
            size: 22,
          ),
        ),
        onPressed: () {
         // Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
        },
      ),

      IconButton(
        padding: EdgeInsets.only(right: 15),
        icon: Badge(badgeContent: Text('2',
          style: TextStyle(color: Colors.white),
        ),
          badgeColor: Colors.green,
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Color(0xFF526FD8),
          ),
        ),
        onPressed: () {
         // Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart()));
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyCart()));
        },
      ),

    ],
  );
}*/

// Used in HomeScreen, WishListScreen
class PrimaryAppBar {
  static AppBar nameofAppBar(BuildContext context) => AppBar(
        elevation: 0.4,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Image.asset(
            "assets/appbar_logo.png",
            height: 30,
          ),
        ),
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Color(0xFF526FD8),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }),
          IconButton(
            padding: EdgeInsets.only(right: 15),
            // icon: Badge(badgeContent: Text('2',
            //   style: TextStyle(color: Colors.white),
            // ),
            //   badgeColor: Colors.green,
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF526FD8),
            ),

            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
          ),
        ],
      );
}

class CategoryPrimaryAppBar {
  static AppBar nameofAppBar(BuildContext context) => AppBar(
        elevation: 0.4,
        automaticallyImplyLeading: true,
        titleSpacing: 0.0,
        title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Categories",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 18.0,
                // letterSpacing: 1.7,
              ),
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Color(0xFF526FD8),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }),
          // Cart Icon
          IconButton(
            padding: EdgeInsets.only(right: 15),
            // icon: Badge(badgeContent: Text('2',
            //   style: TextStyle(color: Colors.white),
            // ),
            //   badgeColor: Colors.green,
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF526FD8),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
          ),
        ],
      );
}

class CategoryNewPrimaryAppBar {
  static AppBar nameofAppBar(BuildContext context) => AppBar(
        // elevation: 0.4,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.only(right: 15),
              // icon: Badge(badgeContent: Text('2',
              //   style: TextStyle(color: Colors.white),
              // ),
              //   badgeColor: Colors.green,
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF526FD8),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyCart()));
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color(0xFF526FD8),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()));
                }),
          ],
        ),
        actions: [
          Container(
            //height: 56,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 18.0,
                  // letterSpacing: 1.7,
                ),
              ),
            ),
          ),
        ],
      );
}

// Used in: Account Screen,
class SecoundaryAppBar {
  static AppBar nameofAppBar(String title) => AppBar(
        elevation: 0.4,
        automaticallyImplyLeading: false,
        title: Text('$title'),
        titleTextStyle: TextStyle(
            color: PrimaryColor, fontSize: 18, fontWeight: FontWeight.w500),
        centerTitle: true,
      );
}
