import 'package:flutter/material.dart';
import 'package:maella_shop/component/header.dart';
import 'package:maella_shop/component/home/gridListItem.dart';
import 'package:maella_shop/component/sidebar.dart';
import 'package:maella_shop/services/productService.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}


class _ShopState extends State<Shop> {
  ProductService _productService = new ProductService();
  List<Map<String,String>> categoryList  = new List();

  void listCategories(){
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    setState(() {
      categoryList = args['category'];
    });
  }

  void listSubCategories(category) async{
    Map subCategory = await _productService.subcategoriesList(category);
    Map args = {'subCategory': subCategory, 'category': category};
    Navigator.pushNamed(context, '/subCategory', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    bool showCartIcon = true;

    listCategories();
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacementNamed(context,'/home');
        return true;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: header('Shop', _scaffoldKey, showCartIcon, context),
          drawer: sidebar(context),
          body: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                GridListItem(),
              ],
            ),
          )
      ),
    );
  }
}
