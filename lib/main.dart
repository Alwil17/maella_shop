import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maella_shop/component/orders/history.dart';
import 'package:maella_shop/component/shop.dart';
import 'package:maella_shop/pages/cart.dart';
import 'package:maella_shop/pages/checkout/addCreditCard.dart';
import 'package:maella_shop/pages/checkout/paymentMethod.dart';
import 'package:maella_shop/pages/checkout/placeOrder.dart';
import 'package:maella_shop/pages/checkout/shippingAddress.dart';
import 'package:maella_shop/pages/checkout/shippingMethod.dart';
import 'package:maella_shop/pages/home.dart';
import 'package:maella_shop/pages/login.dart';
import 'package:maella_shop/pages/onBoardingScreen/onboardingScreen.dart';
import 'package:maella_shop/pages/products/items.dart';
import 'package:maella_shop/pages/products/particularItem.dart';
import 'package:maella_shop/pages/products/subCategory.dart';
import 'package:maella_shop/pages/products/wishlist.dart';
import 'package:maella_shop/pages/profile/contactUs.dart';
import 'package:maella_shop/pages/profile/editProfile.dart';
import 'package:maella_shop/pages/profile/setting.dart';
import 'package:maella_shop/pages/profile/userProfile.dart';
import 'package:maella_shop/pages/register.dart';
import 'package:maella_shop/pages/start.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool firstTime;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstTime = (prefs.getBool('initScreen') ?? false);
  if(!firstTime){
    prefs.setBool('initScreen', true);
  }
  runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => Main(),
      )
  );
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maella',
      initialRoute: firstTime ? '/': '/onBoarding',

      routes: {
        '/': (context) => Start(),
        '/login': (context) => Login(),
        '/signup': (context) => Register(),
        '/home': (context) => Home(),
        '/shop': (context) => Shop(),
        '/subCategory': (context) => SubCategory(),
        '/items': (context) => Items(),
        '/particularItem': (context) => ParticularItem(),
        '/bag': (context) => Cart(),
        '/wishlist': (context) => WishList(),
        '/checkout/addCreditCard': (context) => AddCreditCard(),
        '/checkout/address': (context) => ShippingAddress(),
        '/checkout/shippingMethod': (context) => ShippingMethod(),
        '/checkout/paymentMethod': (context) => PaymentMethod(),
        '/checkout/placeOrder': (context) => PlaceOrder(),
        '/profile': (context) => UserProfile(),
        '/profile/settings': (context) => ProfileSetting(),
        '/profile/edit': (context) => EditProfile(),
        '/profile/contactUs': (context) => ContactUs(),
        '/placedOrder': (context) => OrderHistory(),
        "/onBoarding": (context) => OnBoardingScreen()
      },
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white
          )
      ),
    );
  }
}