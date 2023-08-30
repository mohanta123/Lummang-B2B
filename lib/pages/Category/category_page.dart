import 'package:flutter/material.dart';
import 'package:my_store/pages/Category/best_for_you.dart';
import 'package:my_store/pages/Category/item_discount.dart';
import 'package:my_store/pages/Category/item_popular.dart';
import 'package:my_store/pages/Category/new_item.dart';
import 'package:my_store/pages/Category/sub_category.dart';

import '../../constants/utils/appbar.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;

  CategoryPage({Key key, @required this.categoryName}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    String categoryName = widget.categoryName;

    return Scaffold(
    /*  appBar: AppBar(
        automaticallyImplyLeading: false,

       /* title: Text(
          categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            letterSpacing: 1.7,
          ),
        ),*/
        titleSpacing: 0.0,
      ),*/
      appBar: CategoryPrimaryAppBar.nameofAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              // width: 400,
              color: Colors.pink,
              child: Image(
                  image: AssetImage(
                   // 'assets/category/mens_category/menswear.png',
                    'assets/category/mens_category/11111.jpeg',
                  ),
                  fit: BoxFit.fill
              ),
            ),
           // SizedBox(height: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                       // width: 400,
                        color: Colors.pink,
                        child: Image(
                                image: AssetImage(
                                  'assets/category/womens_category/1.png',
                                ),
                                fit: BoxFit.fill,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           // SizedBox(height: 3,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.blueAccent,
              child: Image(
                  image: AssetImage(
                    'assets/category/cosmetics/cosmatic.png',
                  ),
                  fit: BoxFit.fill
              ),
            ),
           // SizedBox(height: 3,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.green,
              child: Image(
                  image: AssetImage(
                    'assets/category/kids_category/kids_wear.png',
                  ),
                  fit: BoxFit.fill
              ),
            ),
           // SizedBox(height: 3,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.pinkAccent,
              child: Image(
                  image: AssetImage(
                    'assets/category/jewellery/jewellery.png',
                  ),
                  fit: BoxFit.fill
              ),
            ),
           // SizedBox(height: 3,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.greenAccent,
              child: Image(
                  image: AssetImage(
                    'assets/category/stationery/stationary.png',
                  ),
                  fit: BoxFit.fill
              ),
            ),
           // SizedBox(height: 3,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.redAccent,
              child: Image(
                  image: AssetImage(
                    'assets/category/toys/toys&games.png',
                  ),
                  fit: BoxFit.fill
              ),
            ),
          ],
        ),
      ),
     /* ListView(
        shrinkWrap: true,
        children: <Widget>[
          // Best for You Start
          BestForYou(),
          // Best for You End

          SizedBox(height: 10.0,),

          // Sub Category Start
          SubCategory(),
          // Sub Category End

          SizedBox(height: 10.0,),

          // Item Discount Start
          ItemDiscount(),
          // Item Discount End

          SizedBox(height: 10.0),

          // Item Popular Start
          ItemPopular(),
          // Item Popular End

          SizedBox(height: 10.0),

          // New Item Start
          NewItem(),
          // New Item End
        ],
      ),*/
    );
  }
}
