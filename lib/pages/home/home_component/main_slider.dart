import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/urls/urls.dart';

class MainSlider extends StatefulWidget {
  @override
  _MainSliderState createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  @override
  void initState() {
    super.initState();
    getsHomePageBannerLists();
    getsDetails();
  }

  String mobileNumber = "";
  String marketUserId = "";
  void getsDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = prefs.getString("marketUserId");
      mobileNumber = prefs.getString("mobileNumber");
    });
    print(prefs.getString("marketUserId"));
  }

  List HomePageBannerList = [];
  List imageList = [];
  void getsHomePageBannerLists() async {
    String api = getHomePageBannerLists;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh" + mjson.toString());
      setState(() {
        HomePageBannerList = mjson["data"];
        imageList.add(mjson["data"][0]["banner"]);
        imageList.add(mjson["data"][1]["banner"]);
        imageList.add(mjson["data"][2]["banner"]);
        imageList.add(mjson["data"][3]["banner"]);
        // initializeImageList(); // Call the method to initialize imageList
      });
    } else {
      print('api Error');
    }
  }
  int currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return  CarouselSlider(
      options: CarouselOptions(
        scrollPhysics: const BouncingScrollPhysics(),
        autoPlay: true,
        height: deviceHeight*0.2,
        aspectRatio: 2,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      items: [
        for (int i = 0; i < imageList.length; i++)
          Container(
            child: Image.network(
              webBaseUrl + imageList[i],
              fit: BoxFit.cover,
              width: double.infinity,),
          ),
      ],
    );
  }
}
