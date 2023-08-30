import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/Category/category_page.dart';
import 'package:http/http.dart' as http;

class CategoryGrid extends StatefulWidget {
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final categoryList = [
    {'title': 'Men', 'image': 'assets/men_fashion.jpg'},
    {'title': 'Women', 'image': 'assets/women_fashion.jpg'},
    {'title': 'Cosmetics', 'image': 'assets/cosmetic_ban.jpg'},
    {'title': 'Stationary', 'image': 'assets/stationary.jpg'}
  ];

  var stringResponse = '';
  List ApiData = [];

  Future apicall() async {
    var response;
    response =
        await http.get(Uri.parse("https://demo22.appman.in/topcategoriesview"));
    if (response.statusCode == 200) {
      setState(() {
        stringResponse = response.body.toString();
        ApiData = jsonDecode(stringResponse)['data']['topcategories'];
      });
      print(ApiData);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Container getStructuredGridCell(bestOffer) {
      final item = bestOffer;
      return Container(
        margin: EdgeInsets.all(3.0),
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1.5,
                  color: Colors.grey,
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(
                    "https://demo22.appman.in/assets/images/" + item['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              item['categoryid']['categoryname'],
              style: TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryPage(
                    categoryName: item['categoryid']['categoryname']),
              ),
            );
          },
        ),
      );
    }

    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              AppLocalizations.of(context)
                  .translate('homePage', 'categoryString'),
              style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 17.0,
                  color: Theme.of(context).textTheme.headline6.color),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.center,
                width: width - 20.0,
                child: GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  crossAxisCount: 2,
                  childAspectRatio: ((width) / 300),
                  children: List.generate(ApiData.length, (index) {
                    return getStructuredGridCell(ApiData[index]);
                  }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
