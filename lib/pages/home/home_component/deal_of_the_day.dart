import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';

class DealOfTheDay extends StatefulWidget {
  @override
  _DealOfTheDayState createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Category(
            press: (){},
            text : 'New Arrivals',
          ),

          Category(
            press: (){},
            text : 'Tranding Product',
          ),

          Category(
            press: (){},
            text : 'Most Popular',
          ),
        ],
      )
    );
  }
}

class Category extends StatelessWidget {
  const Category({
    Key key,
    @required this.image,
    @required this.text,
    @required this.press,
}) : super(key: key);
  final String image,text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: (){},
        child: Container(
          child: Chip(
            label: Text(text),
          ),
        ),
      ),
    );
  }
}
