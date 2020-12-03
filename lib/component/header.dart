import 'package:flutter/material.dart';
import 'package:maella_shop/component/loader.dart';
import 'package:maella_shop/services/cartService.dart';

capitalizeHeading(String text){
  if(text == null){
    return text = "";
  }
  else{
    text = "${text.toUpperCase()}";
    return text;
  }
}

Widget header(String headerText,GlobalKey<ScaffoldState> scaffoldKey,bool  showIcon, BuildContext context){
  final GlobalKey<State> keyLoader = new GlobalKey<State>();

  CartService _cartService = new CartService();
  return AppBar(
    centerTitle: true,
    title: Text(
      capitalizeHeading(headerText),
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          fontFamily: 'NovaSquare'
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 1.0,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Icon(
          Icons.menu,
          size: 35.0,
          color: Colors.pinkAccent
      ),
      onPressed: (){
        if(scaffoldKey.currentState.isDrawerOpen == false){
          scaffoldKey.currentState.openDrawer();
        }
        else{
          scaffoldKey.currentState.openEndDrawer();
        }
      },
    ),
    actions: <Widget>[
      Visibility(
        visible: showIcon,
        child: IconButton(
          icon: Icon(
            Icons.shopping_cart,
            size: 35.0,
            color: Colors.pinkAccent,
          ),
          onPressed: () async{
            Map<String,dynamic> args = new Map();
            Loader.showLoadingScreen(context, keyLoader);
            List bagItems = await _cartService.list();
            args['bagItems'] = bagItems;
            Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
            Navigator.pushNamed(context, '/bag', arguments: args);
          },
        ),
      )
    ],
  );
}