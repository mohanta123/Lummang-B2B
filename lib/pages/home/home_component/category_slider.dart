import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/Category/category_page.dart';

class CategorySlider extends StatefulWidget {
  @override
  _CategorySliderState createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 135.0,
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 5.0),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryName: AppLocalizations.of(context)
                          .translate('homePage', 'bagsString'),
                    ),
                  ),
                );
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 80.0,
                      height: 80.0,
                      margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1.5,
                            color: Colors.grey,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage("assets/category/bags.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('homePage', 'bagsString'),
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 14.0,
                        letterSpacing: 1.5,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryName: AppLocalizations.of(context)
                          .translate('homePage', 'cameraString'),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.5,
                          color: Colors.grey,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/category/camera.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('homePage', 'cameraString'),
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryName: AppLocalizations.of(context)
                          .translate('homePage', 'speakersString'),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.5,
                          color: Colors.grey,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/category/speakers.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('homePage', 'speakersString'),
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryName: AppLocalizations.of(context)
                          .translate('homePage', 'watchesString'),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.5,
                          color: Colors.grey,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/category/watches.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('homePage', 'watchesString'),
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 14.0,
                      letterSpacing: 1.5,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5.0),
          ],
        ),
      ),
    );
  }
}
