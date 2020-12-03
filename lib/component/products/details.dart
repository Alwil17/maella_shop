import 'package:flutter/material.dart';
import 'package:maella_shop/component/header.dart';
import 'package:maella_shop/component/items/bottomSheet.dart';
import 'package:maella_shop/component/loader.dart';
import 'package:maella_shop/component/sidebar.dart';
import 'package:maella_shop/services/cartService.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class ProductDetails extends StatefulWidget {
  final productDetailsName;
  final productDescription;
  final productId;
  final productDetailsNewPrice;
  final productDetailsPicture;

  ProductDetails(
      {
        this.productDetailsName,
        this.productDetailsPicture,
        this.productId,
        this.productDescription,
        this.productDetailsNewPrice
      });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  int quantity = 1;

  List<bool> selectedColor = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    bool showCartIcon  = true;
    return Scaffold(
      key: _scaffoldKey,
      appBar: header('Details du produit', _scaffoldKey,showCartIcon,context),
      drawer: sidebar(context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildCard(),
            flex: 5,
          ),
          Expanded(
            child: buildChoice(),
          ),
          Expanded(
            child: buildDescription(),
          ),
          Expanded(
            child: buildAddToRow(),
          ),
        ],
      ),
    );
  }

  Widget buildCard() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffdddddd),
        ),
//        width: MediaQuery.of(context).size.width -50,
//        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Image.network(
                  widget.productDetailsPicture,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width - 80,
                ),
                padding: EdgeInsets.all(20),
              ),
              flex: 6,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text("${widget.productDetailsNewPrice} CFA",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              color: Color(0xff36004f),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.pink,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.pink,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.pink,
                              ),
                              Icon(
                                Icons.star_half,
                                color: Colors.pink,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.pink,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget buildChoice() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Quantite :")
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.grey,),
                  onPressed: () {
                    setState(() {
                      quantity = --quantity == 0 ? 1 : quantity;
                    });
                  }),
              Text(quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.grey,),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildColor(Color color, int i) {
    return InkWell(
      onTap: () {
        setState(() {
          for ( int j=0;j<selectedColor.length;j++){
            selectedColor[j] = false;
            if ( j == i )
              selectedColor[j] = true;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 8),
        child: selectedColor[i] ? Icon(Icons.check, size: 15, color: Colors.white,) : null,
        decoration: ShapeDecoration(color: color, shape: CircleBorder()),
        height: 20,
        width: 20,
      ),
    );
  }

  Widget buildAddToRow() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
            child: FlatButton(
                onPressed: () {
                  addToShoppingBag();
                },
                child: Text("AJOUTER AU PANIER",
                  style: TextStyle(color: Colors.white),
                )),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.pinkAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ), flex: 3,),
          Expanded(
            child: Container(
              child: IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: (){
                    showModalBottomSheet(context: context, builder: (context){
                      return ShowBottomScreen();
                    });
                  },
              ),
//            margin: EdgeInsets.only(left: 30, right: 20),
              decoration: ShapeDecoration(shape: CircleBorder(), color: Color(0xffdddddd)),
              padding: EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProduct() {
    return Container(
      height: 200.0,
      child: GridTile(
        child: Container(
          color: Colors.white,
          child: Image.asset(
            widget.productDetailsPicture,
            fit: BoxFit.fitHeight,
          ),
        ),
        footer: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(widget.productDetailsName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text("${widget.productDetailsNewPrice} CFA",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChoicesRow() {
    return Container(
      color: Color(0xffe5e3e3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: buildChoiceButton("Size"),
              margin: EdgeInsets.all(5),
            ),
            flex: 3,
          ),
          Expanded(
              child: Container(
                child: buildChoiceButton("Color"),
                margin: EdgeInsets.all(5),
              ),
              flex: 3),
          Expanded(
            child: Container(
              child: buildChoiceButton("Quantity"),
              margin: EdgeInsets.all(5),
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  Widget buildChoiceButton(String text) {
    return MaterialButton(
      color: Colors.white,
      textColor: Colors.grey,
      elevation: 0.2,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            flex: 2,
          ),
          Expanded(child: Icon(Icons.arrow_drop_down))
        ],
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(text),
                content: Text("Choose the $text"),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    child: Text("close"),
                  )
                ],
              );
            });
      },
    );
  }

  Widget buildBuyRow() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: MaterialButton(
                  onPressed: () {},
                  color: Colors.pink,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: Text("Commander"))),
          IconButton(
              icon: Icon(Icons.add_shopping_cart),
              color: Colors.pink,
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.favorite_border),
              color: Colors.pink,
              onPressed: () {

              })
        ],
      ),
    );
  }

  Widget buildDescription() {
    return ListTile(
      title: Text("${widget.productDetailsName}"),
      subtitle: Text("${widget.productDescription}"),
    );
  }

  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  var itemDetails;

  void showInSnackBar(String msg, Color color) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: new Text(msg),
        action: SnackBarAction(
          label:'Close',
          textColor: Colors.white,
          onPressed: (){
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ),
    );
  }

  addToShoppingBag() async{
    Loader.showLoadingScreen(context, keyLoader);
    CartService _shoppingBagService = new CartService();
    String msg = await _shoppingBagService.add(widget.productId,quantity);
    Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
    showInSnackBar(msg,Colors.black);
  }
}