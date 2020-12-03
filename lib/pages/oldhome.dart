import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maella_shop/component/header.dart';
import 'package:maella_shop/component/home/categoryCarousel.dart';
import 'package:maella_shop/component/products/category.dart' as Cat;
import 'package:maella_shop/component/home/gridListItem.dart';
import 'package:maella_shop/component/home/snapEffectCarousel.dart';
import 'package:maella_shop/component/sidebar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var categories = [
    {
      'title': 'Women',
      'img': 'img/dress.jpg',
    },
    {
      'title': 'Men',
      'img': 'img/men.jpg',
    },
    {
      'title': 'Kids',
      'img': 'img/children.jpg',
    },
    {
      'title': 'House',
      'img': 'img/house.jpg',
    },
    {
      'title': 'Cars',
      'img': 'img/cars.jpg',
    },
    {
      'title': 'Electronics',
      'img': 'img/electronics.jpg',
    },
  ];
  Widget buildTitle(String title) {
    return Center(
      child: Container(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Colors.white, style: BorderStyle.solid)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    bool showCartIcon  = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return WillPopScope(
      onWillPop: () async{
        return(
            await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)
                  ),
                  title: Text('Etes-vous sur ?'),
                  content: Text('Voulez vous vraiment quitter l\'application ?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                          'No',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                      ),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          )
                      ),
                    )
                  ],
                )
            )
        ) ?? false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: header('Maella', _scaffoldKey,showCartIcon,context),
          drawer: sidebar(context),
          body: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        height: 80.0,
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.8),
                            itemCount: 6,
                            itemBuilder: (context, i) {
                              return InkWell(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Card(
                                    elevation: 2,
                                    child: Container(
                                      child: Container(
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                        child: buildTitle(categories[i]['title']),
                                      ),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(categories[i]['img']),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Cat.Category(
                                            title: categories[i]['title'],
                                          )))
                                },
                              );
                            })
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 20.0),
                      child: Center(
                        child: Text(
                          'Categories',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 80.0,
                        child: CategoryCarousal()
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 20.0),
                      child: Center(
                        child: Text(
                          'Nouveaux produits',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 420.0,
                        child: SnapEffectCarousel()
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0,bottom: 15.0),
                      child: Center(
                        child: Text(
                          'Populaires',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                GridListItem(),
              ],
            ),
          )
      ),
    );
  }
}