import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_store/functions/localizations.dart';


// My Own Imports
import 'package:my_store/pages/home/home_main.dart';
import 'package:my_store/pages/my_account/my_account.dart';
import 'package:my_store/pages/notification.dart';
import 'package:my_store/pages/wishlist.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../functions/customStyle.dart';
import '../../functions/prefs_file.dart';
import '../Category/category_list/category.dart';
import '../Category/category_page.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 5,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0.1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ],
        ),
        child: SalomonBottomBar(
          onTap: changePage,
          currentIndex: currentIndex,
          selectedItemColor:  Color(0xFF526FD8),
          unselectedItemColor: Colors.black.withOpacity(0.5),
          items: <SalomonBottomBarItem>[
            SalomonBottomBarItem(icon: Icon(EvaIcons.home), title: Text('Home',style: NavigationPrimaryTextStyle.nameofTextStyle(),)),
            SalomonBottomBarItem(icon: Icon(Icons.category), title: Text('Category',style: NavigationPrimaryTextStyle.nameofTextStyle(),)),
            SalomonBottomBarItem(icon: Icon(Icons.favorite_border_outlined), title: Text('WishList',style: NavigationPrimaryTextStyle.nameofTextStyle(),)),
            SalomonBottomBarItem(icon: Icon(EvaIcons.bell), title: Text('Notification',style: NavigationPrimaryTextStyle.nameofTextStyle(),)),
            SalomonBottomBarItem(icon: Icon(EvaIcons.person), title: Text('Profile',style: NavigationPrimaryTextStyle.nameofTextStyle(),)),
          ],
        ),
      ),
      body: WillPopScope(
        child: (currentIndex == 0)
            ? HomeMain()
            : (currentIndex == 1)
                ? Category(categoryName: 'categoryName',)
        : (currentIndex == 2)
          ? WishList()
                : (currentIndex == 3)
                    ? Notifications()
                    : MyAccount(),
        onWillPop: () async {
          bool backStatus = onWillPop();
          if (backStatus) {
            exit(0);
          }
          return false;
        },
      ),
    );
  }
  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)
            .translate('homePage', 'exitToastString'),
        backgroundColor: Theme.of(context).textTheme.headline6.color,
        textColor: Theme.of(context).appBarTheme.backgroundColor,
      );
      return Future.value(false);
    } else {
      return true;
    }
  }
}
