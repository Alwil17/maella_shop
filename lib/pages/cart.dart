import 'dart:math' as math;
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maella_shop/component/cart/cartExpandedList.dart';
import 'package:maella_shop/component/header.dart';
import 'package:maella_shop/component/items/customTransition.dart';
import 'package:maella_shop/component/loader.dart';
import 'package:maella_shop/component/sidebar.dart';
import 'package:maella_shop/pages/products/particularItem.dart';
import 'package:maella_shop/services/cartService.dart';
import 'package:maella_shop/services/productService.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List <dynamic>bagItemList = new List<dynamic>();
  String selectedSize, selectedColor, totalPrice;
  CartService _cartService = new CartService();
  ProductService _productService = new ProductService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String route;

  void listBagItems(context) async {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    setState(() {
      bagItemList = args['bagItems'];
      totalPrice = setTotalPrice(args['bagItems']);
      if(args.containsKey('route')){
        route = args['route'];
      }
    });
  }

  String setTotalPrice(List items){
    int totalPrice = 0;
    items.forEach((item){
      totalPrice = totalPrice + (int.parse(item['price']) * item['quantity']);
    });
    return totalPrice.toString();
  }

  String colorList(String colorName){
    Map colorMap = new Map();
    colorMap['000000'] = 'Black';
    colorMap['0000ff'] = 'Blue';
    colorMap[''] = 'None';
    return colorMap[colorName];
  }

  void removeItem(item,context) async{
    bagItemList.removeWhere((items) => items['id'] == item['id']);
    await _cartService.remove(item['id']);
    setState(() {
      bagItemList = bagItemList;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  void removeItemAlertBox(BuildContext context, Map id) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)
            ),
            title: Text(
              'Retirer du panier',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0
              ),
            ),
            content: Text(
              'Le produit sera retire du panier',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: (MediaQuery.of(context).size.width - 120) /2,
                    child: FlatButton(
                      onPressed: (){
                        removeItem(id,context);
                      },
                      child: Text(
                        'Retirer',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.redAccent
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ButtonTheme(
                    minWidth: (MediaQuery.of(context).size.width - 120) /2,
                    child: FlatButton(
                      onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0)
                ],
              )
            ],
          );
        }
    );
  }

  openParticularItem(Map item) async{
    Map<String,dynamic> args = new Map();
    args['itemDetails'] = item;
    Navigator.pushReplacement(
        context,
        CustomTransition(
            type: CustomTransitionType.downToUp,
            child: ParticularItem(
              itemDetails: args,
              edit: true,
            )
        )
    );
  }

  nonExistingBagItems(){
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Desole, aucun produit dans le panier.',
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
            SizedBox(height: 10.0),
            ButtonTheme(
              height: 45.0,
              minWidth: 100.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0))
              ),
              child: RaisedButton(
                color: Color(0xff313134),
                onPressed: () async{
                  Map<String,dynamic> args = new Map();
                  Loader.showLoadingScreen(context, _keyLoader);
                  List<Map<String,String>> categoryList = await _productService.categoriesList();
                  args['category'] = categoryList;
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  Navigator.pushReplacementNamed(context, '/shop',arguments: args);
                },
                child: Text(
                  'Shop',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  expandedListBuilder(){
    return ListView.builder(
      itemCount: bagItemList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = bagItemList[index];
        return ExpandableNotifier(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ScrollOnExpand(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment: ExpandablePanelHeaderAlignment.center,
                            tapBodyToExpand: true,
                            tapBodyToCollapse: true,
                            hasIcon: false,
                          ),
                          header: Container(
                            color: Colors.indigoAccent,
                            child: Row(
                              children: [
                                Image(
                                  image: NetworkImage(
                                    item['image']
                                  ),
                                  height: 100.0,
                                  width: 120.0,
                                  fit: BoxFit.fill,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          item['name'],
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              letterSpacing: 1.0),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          "${item['price']} CFA",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ExpandableIcon(
                                  theme: const ExpandableThemeData(
                                    expandIcon: Icons.keyboard_arrow_right,
                                    collapseIcon: Icons.keyboard_arrow_down,
                                    iconColor: Colors.white,
                                    iconSize: 28.0,
                                    iconRotationAngle: math.pi / 2,
                                    iconPadding: EdgeInsets.only(right: 5),
                                    hasIcon: false,
                                  ),
                                )
                              ],
                            ),
                          ),
                          expanded: CartExpandedList(item, colorList, openParticularItem, removeItemAlertBox)
                      ),
                    ],
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    bool showCartIcon = false;
    listBagItems(context);
    return WillPopScope (
      onWillPop: () async{
        if(this.route != null){
          Navigator.pushReplacementNamed(context, route);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        appBar: header('Panier', _scaffoldKey, showCartIcon, context),
        drawer: sidebar(context),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 0.0),
            child: Container(
              height: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          '${totalPrice} CFA',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))
                    ),
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50.0,
                    child: RaisedButton(
                      color: Color(0xff313134),
                      onPressed: (){
                        if(bagItemList.length != 0){
                          Map<String,dynamic> args = new Map<String, dynamic>();
                          args['price'] = totalPrice.toString();
                          Navigator.of(context).pushNamed('/checkout/address',arguments: args);
                        }
                      },
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Container(
            child: bagItemList.length == 0 ? nonExistingBagItems() : expandedListBuilder()
        ),
      ),
    );
  }
}
