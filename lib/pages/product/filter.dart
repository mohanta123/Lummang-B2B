import 'package:flutter/material.dart';

class Filterr extends StatefulWidget {


  @override
  State<Filterr> createState() => _FilterrState();
}

class _FilterrState extends State<Filterr> {
  final List<Map<String, dynamic>> Item = [
    {"ItemName": "Category"},
    {"ItemName": "Price"},
    {"ItemName": "Barnd"},
    {"ItemName": "Colors"},
  ];
  bool isChecked1 = false;
  bool isChecked2 = false;
  int current = 0;

  List<bool> _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(catName.length, false);
  }

  final List<Map<dynamic, dynamic>> catName = [
    {
      "data": [
        {
          "title": "Sea Food",
          "subtitle": "Best experience so pleasant",
          "price": "201",
        },
        {
          "title": "Burger",
          "subtitle": "Best experience so pleasants",
          "price": "202",
        },
        {
          "title": "MockTail",
          "subtitle": "Best experience so pleasant",
          "price": "203",
        },
        {
          "title": "Cake",
          "subtitle": "Best experience so pleasant",
          "price": "204",
        },
        {
          "title": "Cake",
          "subtitle": "Best experience so pleasant",
          "price": "205",
        },
      ],
    },
    {
      "meta": [
        {
          "title": "North Indian",
          "subtitle": "Best experience so pleasants",
          "images": "assets/north_indian_food.jpg",
          "price": "202",
        },
        {
          "title": "Cheese Burger",
          "subtitle": "Best experience so pleasants",
          "images": "assets/cheeseburger_pizza.jpg",
          "price": "202",
        },
        {
          "title": "DrinkStock",
          "subtitle": "Best experience so pleasant",
          "images": "assets/drinkstock.jpg",
          "price": "203",
        },
        {
          "title": "Blue Berry",
          "subtitle": "Best experience so pleasant",
          "images": "assets/blubarry_cake.jpg",
          "price": "204",
        },
        {
          "title": "South Indian",
          "subtitle": "Best experience so pleasant",
          "images": "assets/1.jpg",
          "price": "205",
        },
      ],
    },
    {
      "beta": [
        {
          "title": "Chinese",
          "subtitle": "Best experience so pleasant",
          "images": "assets/chinesefood.png",
          "price": "203",
        },
        {
          "title": "Grilled Pizza",
          "subtitle": "Best experience so pleasants",
          "images": "assets/Grilled Pizza.jpg",
          "price": "202",
        },
        {
          "title": "Drink Stock",
          "subtitle": "Best experience so pleasant",
          "images": "assets/drink stock.jpg",
          "price": "203",
        },
        {
          "title": "Vanila Cake",
          "subtitle": "Best experience so pleasant",
          "images": "assets/Naked-Cake.jpg",
          "price": "204",
        },
        {
          "title": "South Indian",
          "subtitle": "Best experience so pleasant",
          "images": "assets/1.jpg",
          "price": "205",
        },
      ],
    },
    {
      "peta": [
        {
          "title": "Tandoor",
          "subtitle": "Best experience so pleasant",
          "images": "assets/tandoor.jpeg",
          "price": "204",
        },
        {
          "title": "Chicken Pizza",
          "subtitle": "Best experience so pleasants",
          "images": "assets/jhatpat_chicken_pizza.jpg",
          "price": "202",
        },
        {
          "title": "Caloria",
          "subtitle": "Best experience so pleasant",
          "images": "assets/calaroia_.jpg",
          "price": "203",
        },
        {
          "title": "Strawberry Cake",
          "subtitle": "Best experience so pleasant",
          "images": "assets/Strawberry-Eton-Mess.png",
          "price": "204",
        },
        {
          "title": "South Indian",
          "subtitle": "Best experience so pleasant",
          "images": "assets/1.jpg",
          "price": "205",
        },
      ],
    },
    {
      "seta": [
        {
          "title": "South Indian",
          "subtitle": "Best experience so pleasant",
          "images": "assets/1.jpg",
          "price": "205",
        },
        {
          "title": "Stuffed Pizza",
          "subtitle": "Best experience so pleasants",
          "images": "assets/stuffed_pizza.jpg",
          "price": "202",
        },
        {
          "title": "Cocktails",
          "subtitle": "Best experience so pleasant",
          "images": "assets/Cocktails.jpg",
          "price": "203",
        },
        {
          "title": "Jello Cake",
          "subtitle": "Best experience so pleasant",
          "images": "assets/jello poke cake.jpg",
          "price": "204",
        },
        {
          "title": "South Indian",
          "subtitle": "Best experience so pleasant",
          "images": "assets/1.jpg",
          "price": "205",
        },
      ],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter"),
        ),
        body: Row(
          children: [
            ///category container
            Container(
              height: double.infinity,
              width: 170,
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: Item.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  current = index;
                                });
                                Item[index]["ItemName"];
                                // getOnlySubCategoryList(current.toString());
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.all(0.8),
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: current == index
                                      ? Colors.white
                                      : Colors.white54,
                                  borderRadius: current == index
                                      ? BorderRadius.circular(3)
                                      : BorderRadius.circular(3),
                                  border: current == index
                                      ? Border.all(
                                      color: Colors.white, width: 2)
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    Item[index]["ItemName"],
                                    style: TextStyle(
                                        fontWeight: current == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),

                            // Visibility(
                            //     visible: current == index,
                            //     child: Container(
                            //       width: 5,
                            //       height: 5,
                            //       decoration: const BoxDecoration(
                            //           color: Colors.red,
                            //           shape: BoxShape.circle),
                            //     )),
                          ],
                        );
                      }),
                ],
              ),
            ),
            ///checkbox container
            Container(
              height: double.infinity,
              width: 200,
              child: ListView.builder(
                itemCount: catName.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final categoryData = catName[index];
                  final itemList = categoryData.values.first;
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Category_page(
                      //       itemList[current]["title"].toString(),
                      //       itemList[current]["images"].toString(),
                      //       itemList[current]["price"].toString(),
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            activeColor: Colors.green,
                            value: _isChecked[index],
                            onChanged: (val) {
                              setState(() {
                                _isChecked[index] = val;
                              });
                            },
                          ),
                          Text(
                            itemList[current]["title"].toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      //  itemList[current]["title"].toString(),
    );
  }
}