import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class TopBrand extends StatefulWidget {
  const TopBrand({Key key}) : super(key: key);

  @override
  State<TopBrand> createState() => _TopBrandState();
}

class _TopBrandState extends State<TopBrand> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          CarouselSlider(
            // height: 180.0,
            // autoPlay: true,
            // viewportFraction: 0.8,
            // enableInfiniteScroll: true,
            // enlargeCenterPage: false,
            items: [
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProductListView()));
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage("assets/home_slider/home_slider_1.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProductListView()));
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage("assets/home_slider/home_slider_2.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProductListView()));
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage("assets/home_slider/home_slider_3.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
