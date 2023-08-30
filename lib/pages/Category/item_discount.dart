import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';

class ItemDiscount extends StatefulWidget {
  @override
  _ItemDiscountState createState() => _ItemDiscountState();
}

class _ItemDiscountState extends State<ItemDiscount> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 295.0,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate('categoryPage', 'itemDiscountString'),
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProductListView(),
                    //   ),
                    // );
                  },
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
          ),

        ],
      ),
    );
  }
}
