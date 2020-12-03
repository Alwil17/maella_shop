import 'package:flutter/material.dart';
import 'package:maella_shop/component/profileAppBar.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showCartIcon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: ProfileAppBar('Nous contacter', context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'CONTACT',
                style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 1.0
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Notre adresse',
                  style: TextStyle(
                      fontSize:20.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  '116 rue des cannards, Lome, Togo.',
                  style: TextStyle(
                      fontSize:16.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  'Envoyez-nous un mail',
                  style: TextStyle(
                      fontSize:20.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                trailing: Text(
                  'info@maella.shop',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 10.0),
              child: Text(
                  'Nous sommes ouverts Lundi - Vendredi, 08h - 18h, \n Samedi de 08h - 12h'
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Center(
                  child: Text(
                    'Appelez-nous: +228 ',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
