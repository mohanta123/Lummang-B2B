import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';

class SubCategory extends StatefulWidget {
  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.all(10.0),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate('categoryPage', 'subCategory'),
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  AppLocalizations.of(context)
                      .translate('categoryPage', 'seeMoreString'),
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                child: Text(
                    AppLocalizations.of(context)
                        .translate('categoryPage', 'stylishString'),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 13.0,
                    )),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                child: Text(
                    AppLocalizations.of(context)
                        .translate('categoryPage', 'traditionalString'),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 13.0,
                    )),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                child: Text(
                    AppLocalizations.of(context)
                        .translate('categoryPage', 'valueForMoneyString'),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 13.0,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
