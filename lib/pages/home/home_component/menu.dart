import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import '../../../constants/urls/urls.dart';
import '../../Category/category_list/category_screen.dart';


class HomeCategoryMenu extends StatefulWidget {
  const HomeCategoryMenu({Key key}) : super(key: key);


  @override
  _HomeCategoryMenuState createState() => _HomeCategoryMenuState();
}

class _HomeCategoryMenuState extends State<HomeCategoryMenu> {



  @override
  void initState() {
    super.initState();
    parentCategorylist();
  }



  List getParentCategorylist=[];
  void parentCategorylist() async {
    String api = getParentCategoryList;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200){
      Map mjson = json.decode(response.body);
      setState(() {
        getParentCategorylist=mjson["data"];
      });
    } else {
      print('api Error');
    }
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeInUp(
          delay: Duration(milliseconds: 45),
          child: Container(
            //  color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: getParentCategorylist.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                              getParentCategorylist[index]["categoryId"].toString(),getParentCategorylist[index]["categoryName"].toString())));
                    },
                    child: Container(
                      width: 70,
                      child: Column(
                        children: [
                          SizedBox(height: 2,),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            backgroundImage: NetworkImage(webBaseUrl + getParentCategorylist[index]["icon"],),
                          ),
                          SizedBox(height: 5,),
                          Flexible(
                            child: Text(
                              getParentCategorylist[index]["categoryName"],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  /* Stack(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => WomensWearScreen(
                                    getParentCategorylist[index]["categoryId"].toString(),getParentCategorylist[index]["categoryName"].toString())));
                        },
                        child: Container(
                          child: Card(
                            elevation: 3,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.pink,
                                            Colors.blue,
                                            Colors.green,
                                            Colors.yellow,
                                          ]
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.5),
                                    child: Container(
                                      width: 70,
                                      height: 65,
                                      decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)
                                          ),
                                          color: Colors.white,
                                          image:  DecorationImage(
                                            image: NetworkImage(imageBaseUrl + getParentCategorylist[index]["icon"],),
                                            fit: BoxFit.fill,
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  getParentCategorylist[index]["categoryName"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                  );*/
                }
            ),
          ),
        ),
      ],
    );
  }
}