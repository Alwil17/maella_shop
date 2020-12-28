import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maella_shop/component/header.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:maella_shop/component/products/details.dart';
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
  Widget buildCategories() {
    return Container(
//      height: MediaQuery.of(context).size.height / 8,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          buildSingleCategory(
            imgLocation: "img/cats/tshirt.png",
            imgCaption: "T shirt",
          ),
          buildSingleCategory(
            imgLocation: "img/cats/shoe.png",
            imgCaption: "Shoes",
          ),
          buildSingleCategory(
            imgLocation: "img/cats/jeans.png",
            imgCaption: "Jeans",
          ),
          buildSingleCategory(
            imgLocation: "img/cats/informal.png",
            imgCaption: "Informal",
          ),
          buildSingleCategory(
            imgLocation: "img/cats/formal.png",
            imgCaption: "Formal",
          ),
          buildSingleCategory(
            imgLocation: "img/cats/dress.png",
            imgCaption: "Dress",
          ),
          buildSingleCategory(
            imgLocation: "img/cats/accessories.png",
            imgCaption: "Accessories",
          ),
        ],
      ),
    );
  }

  Widget buildSingleCategory({String imgLocation, String imgCaption}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        splashColor: Colors.lightBlueAccent,
        onTap: () {},
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            children: <Widget>[
              Image.asset(
                imgLocation,
                scale: 3.5,
              ),
              Text(
                imgCaption,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSwiper() {
    List<String> imgs = [
      'img/c1.jpg',
      'img/m1.jpeg',
      'img/m2.jpg',
      'img/w1.jpeg',
      'img/w3.jpeg',
      'img/w4.jpeg',
    ];

    return Swiper(
      outer: false,
      itemBuilder: (context, i) {
        return Image.asset(imgs[i], fit: BoxFit.cover,);
      },
      autoplay: true,
      duration: 300,
      pagination: new SwiperPagination(margin: new EdgeInsets.all(5.0)),
      itemCount: imgs.length,
    );
  }

  Widget buildImgCarousel() {
    return Container(
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('img/c1.jpg'),
          AssetImage('img/m1.jpeg'),
          AssetImage('img/m2.jpg'),
          AssetImage('img/w1.jpeg'),
          AssetImage('img/w3.jpeg'),
          AssetImage('img/w4.jpeg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 5.0,
        indicatorBgPadding: 2.0,
        // dotColor: Colors.blue,
      ),
    );
  }

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
    DatabaseService db = new DatabaseService();
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
          body: Column(
            children: <Widget>[
              Expanded(
                child: buildSwiper(),
                flex: 2,
              ),
              Expanded(
                child: buildCategories(),
                flex: 1,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<dynamic>(stream: db.streamProducts(),
                        builder: (context, snapshot) {
                          if (!(snapshot.hasData)) {
                            return Center( child: CircularProgressIndicator(), );
                          } else {
                            return GridView.builder(
                              itemCount: snapshot.data.documents.length,
                              gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: Card(
                                    elevation: 10,
                                    margin: EdgeInsets.all(10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2.25,
                                      height: MediaQuery.of(context).size.height / 3,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              children: <Widget>[
                                                Image.network(
                                                  snapshot.data.documents[index]['image'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            flex: 5,
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                snapshot.data.documents[index]['name'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text("${snapshot.data.documents[index]['price']}",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w800, color: Colors.red)),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${snapshot.data.documents[index]['price']}",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w400,
                                                          decoration: TextDecoration.lineThrough),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            flex: 2,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () => Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                            //navigate to detailed page with passing data
                                            productDetailsName: snapshot.data.documents[index]['name'],
                                            productDetailsPicture: snapshot.data.documents[index]['image'],
                                            productDescription: snapshot.data.documents[index]['description'],
                                            productId: snapshot.data.documents[index]['productId'],
                                            productDetailsNewPrice: snapshot.data.documents[index]['price'],
                                          ))),
                                );
                              },
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                flex: 4,
              )
            ],
          ),
      ),
    );
  }
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<dynamic> streamProducts()
  {
    return _db.collection('products').snapshots();
  }

}
class ScreenArguments {
  final String id;
  ScreenArguments(this.id);
}