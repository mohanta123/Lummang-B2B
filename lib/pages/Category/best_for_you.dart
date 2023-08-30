import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';

class BestForYou extends StatefulWidget {
  @override
  _BestForYouState createState() => _BestForYouState();
}

class _BestForYouState extends State<BestForYou> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 205.0,
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              AppLocalizations.of(context)
                  .translate('categoryPage', 'bestForYouString'),
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.7,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          Container(
            width: width,
            height: 150.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(width: 10.0),
                Container(
                  height: 150.0,
                  width: 150.0,
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
                          image: AssetImage('assets/category_grid/bags.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        'BAGS',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 10.0),
                Container(
                  height: 150.0,
                  width: 150.0,
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
                          image: AssetImage('assets/category_grid/camera.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        'CAMERA',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 10.0),
                Container(
                  height: 150.0,
                  width: 150.0,
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
                          image:
                              AssetImage('assets/category_grid/speakers.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        'SPEAKERS',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 10.0),
                Container(
                  height: 150.0,
                  width: 150.0,
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
                          image: AssetImage('assets/category_grid/watches.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        'WATCHES',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
