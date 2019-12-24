import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dishModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UNI Resto Cafe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final String url = 'http://www.mocky.io/v2/5dfccffc310000efc8d2c1ad';
  var response;
  List<dynamic> menuList;
  List<String> categories = List();
  String title = "";

//  List<Dish> dishes = List();
  TabController _tabController;
  Map<String, int> dishCount = new HashMap();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

//  _onPositionChange() {
//    setState(() {});
//  }

  Future<String> getData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    response = jsonDecode(res.body)[0];
    title = response["restaurant_name"];
    menuList = response["table_menu_list"];
    menuList.forEach((element) {
      categories.add(element["menu_category"].toString());
    });
    _tabController = TabController(length: categories.length, vsync: this);

//    _onPositionChange();
    setState(() {});
    return "Success";
  }

  String calcTotalCart() {
    int total = 0;
    for (int i in dishCount.values) {
      total += i;
    }
    return total.toString();
  }

  Widget eachTab(int index) {
    List<Dish> dishesEach = List();
    List<dynamic> dishList = menuList[index]['category_dishes'];
    dishList.forEach((element) {
      bool isCust = false;
      List<dynamic> cust = element["addonCat"];
      if (cust.length != 0) {
        isCust = true;
      }
      print(element['dish_image'].toString());
      dishesEach.add(Dish(
          dishID: element['dish_id'].toString(),
          dishName: element['dish_name'].toString(),
          dishPrice: element['dish_price'].toString(),
          dishCurrency: element['dish_currency'].toString(),
          dishCalories: element['dish_calories'].toString(),
          dishDesc: element['dish_description'].toString(),
          dishType: element['dish_Type'].toString(),
          dishImage: element['dish_image'].toString(),
          isCustomizationAvailable: isCust));
    });
    return ListView.builder(
      itemBuilder: (context, position) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                dishesEach[position].dishType == "2"
                    ? Icon(
                        Icons.adjust,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.adjust,
                        color: Colors.red,
                      ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dishesEach[position].dishName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            dishesEach[position].dishCurrency +
                                " " +
                                dishesEach[position].dishPrice,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              dishesEach[position].dishCalories + " calories",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 5),
                        child: Text(
                          dishesEach[position].dishDesc,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            elevation: 0,
                            onPressed: () {
//                                        dishCount[dishesEach[position].dishID] =
                              if (dishCount[dishesEach[position].dishID] !=
                                      null &&
                                  dishCount[dishesEach[position].dishID] > 0) {
//                                          dishCount[dishesEach[position].dishID] =
                                dishCount[dishesEach[position].dishID]--;
                              } else {
                                dishCount[dishesEach[position].dishID] = 0;
                              }

                              print(dishCount);
                              setState(() {});
                            },
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(18),
                                topLeft: Radius.circular(18),
                              ),
//                                    side: BorderSide(color: Colors.green),
                            ),
                          ),
                          Container(
                            color: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                dishCount[dishesEach[position].dishID] == null
                                    ? "0"
                                    : dishCount[dishesEach[position].dishID]
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.5),
                              ),
                            ),
                          ),
                          RaisedButton(
                            elevation: 0,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (dishCount[dishesEach[position].dishID] !=
                                  null) {
//                                          dishCount[dishesEach[position].dishID] =
                                dishCount[dishesEach[position].dishID]++;
                              } else {
                                dishCount[dishesEach[position].dishID] = 1;
                              }
                              print(dishCount);
                              setState(() {});
                            },
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(18),
                                topRight: Radius.circular(18),
                              ),
//                                    side: BorderSide(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      dishesEach[position].isCustomizationAvailable
                          ? Text(
                              "Customizations available",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Image.network(
                  dishesEach[position].dishImage,
                  width: 80,
                  height: 80,
                )
              ],
            ),
          ),
        );
      },
      itemCount: dishesEach.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text(
                "My Orders",
                style: TextStyle(color: Colors.black38),
              ),
            ),
            IconButton(
              icon: Stack(
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.black38,
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: new Text(
                        calcTotalCart(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: TextStyle(color: Colors.black38),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black38,
            isScrollable: true,
            tabs: List<Widget>.generate(categories.length, (int index) {
              return Tab(
                text: categories[index],
              );
            }),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: List<Widget>.generate(
            categories.length,
            (int index) {
              return eachTab(index);
            },
          ),
        ),
      ),
    );
  }
}

