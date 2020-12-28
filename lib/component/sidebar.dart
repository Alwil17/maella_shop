import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maella_shop/component/loader.dart';
import 'package:maella_shop/services/cartService.dart';
import 'package:maella_shop/services/checkoutService.dart';
import 'package:maella_shop/services/productService.dart';
import 'package:maella_shop/services/profileService.dart';
import 'package:maella_shop/services/userService.dart';

Widget sidebar(BuildContext context){
  // call this in initState for example
  FirebaseAuth _auth = FirebaseAuth.instance;
  final User user =  _auth.currentUser;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  UserService _userService = new UserService();
  CartService _cartService = new CartService();
  ProfileService _profileService = new ProfileService();
  ProductService _productService = new ProductService();
  CheckoutService _checkoutService = new CheckoutService();

  return SafeArea(
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: UserAccountsDrawerHeader(
//              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("img/mazzad.png"))),
              accountName: Text("UserName"),
              accountEmail: Text("${user.email}"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("img/logo.png"),
                radius: 50,
              ),
            ),
          ),
          ListTile(
                leading: Icon(Icons.home),
                title:Text(
                  'ACCUEIL',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
          ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(
                  'SHOP',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  Map<String,dynamic> args = new Map();
                  Loader.showLoadingScreen(context, _keyLoader);
                  List<Map<String,String>> categoryList = await _productService.categoriesList();
                  args['category'] = categoryList;
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  Navigator.pushReplacementNamed(context, '/shop',arguments: args);
                },
              ),
          ListTile(
                leading: Icon(Icons.local_mall),
                title: Text(
                  'PANIER',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  Map<String,dynamic> args = new Map();
                  Loader.showLoadingScreen(context, _keyLoader);
                  List bagItems = await _cartService.list();
                  args['bagItems'] = bagItems;
                  args['route'] = '/home';
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  Navigator.pushReplacementNamed(context, '/bag', arguments: args);
                },
              ),
          ListTile(
                leading: Icon(Icons.search),
                title: Text(
                  'RECHERCHER',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
              ),
          ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text(
                  'COMMANDES',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async {
//                  Loader.showLoadingScreen(context, _keyLoader);
                  List orderData = await _checkoutService.listPlacedOrder();
//                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  Navigator.popAndPushNamed(context, '/placedOrder',arguments: {'data': orderData});
                },
              ),
          ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text(
                  'FAVORIS',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  Loader.showLoadingScreen(context, _keyLoader);
                  List userList = await _userService.userWishlist();
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  Navigator.popAndPushNamed(context, '/wishlist',arguments: {'userList':userList});
                },
              ),
          ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'PROFIL',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  Loader.showLoadingScreen(context, _keyLoader);
                  Map userProfile = await _profileService.getUserProfile();
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  Navigator.popAndPushNamed(context, '/profile',arguments: userProfile);
                },
              ),
          ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: Text(
                  'DECONNEXION',
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: (){
                  _userService.logOut(context);
                },
              )
        ],
      )
    ),
  );
}
