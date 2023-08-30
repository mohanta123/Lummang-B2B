import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewMainSlider extends StatefulWidget {
  @override
  State<NewMainSlider> createState() => _NewMainSliderState();
}

List<dynamic> ima = [
  Image.asset("assets/logo.png"),
  Image.asset("assets/logo.png")
];

class _NewMainSliderState extends State<NewMainSlider> {
  @override
  Widget build(BuildContext context) {
    carousel_images() async {
      var url = 'https://demo22.appman.in/api/cms/getimagesliders';

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var itemCount = jsonResponse['data'];
        var slider = itemCount['imagesliders'];

        List tags = slider != null ? List.from(slider) : null;

        setState(() {
          ima.clear();
          for (var i in tags) {
            //var abc = jsonDecode(i.toString());
            // print(abc['image']);
            //print(i['image']);

            ima.add(Image.network(
              "https://demo22.appman.in/assets/images/" + i['image'],
              fit: BoxFit.cover,
            ));
          }

          return ima;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    setState(() {
      carousel_images();
    });

    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 170.0,
      width: width,
      child: Carousel(
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotColor: Theme.of(context).primaryColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: true,
        dotVerticalPadding: 5.0,
        dotPosition: DotPosition.bottomRight,
        images: ima,
        // images: [
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => ProductListView()));
        //     },
        //     child: Image.network(
        //       ima[0],
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => ProductListView()));
        //     },
        //     child: Image.network(
        //       ima[1],
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => ProductListView()));
        //     },
        //     child: Image.network(
        //       ima[2],
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ],
      ),
    );
  }
}
