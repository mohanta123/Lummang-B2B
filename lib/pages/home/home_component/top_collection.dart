import 'package:flutter/material.dart';

//import '../../product_list_view/scrollview_product.dart';

class TopCollection extends StatefulWidget {
  const TopCollection({Key key}) : super(key: key);

  @override
  State<TopCollection> createState() => _TopCollectionState();
}

class _TopCollectionState extends State<TopCollection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:EdgeInsets.only(left: 10,right: 10,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Top Collection",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text("See All",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        //ScrollViewProducts(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: 210,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // itemCount: categoryItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Card(
                              //elevation: 3,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Container(
                                      width: 150,
                                      height: 200,
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),

                                        image: DecorationImage(
                                            image: AssetImage(
                                              'assets/products/01.png',
                                            ),
                                            fit: BoxFit.fill
                                        ),
                                      ),
                                    ),
                                  ),
                                  /* const SizedBox(height: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Smart Watch",
                                        // textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text("\₹1600",
                                        // textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ],
                                  ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),
          ],
        ),
      ],
    );
  }
}
