import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maella_shop/component/items/productImage.dart';
import 'package:maella_shop/component/loader.dart';
import 'package:maella_shop/services/cartService.dart';

class ParticularItem extends StatefulWidget {
  final Map <String,dynamic> itemDetails;
  final bool edit;

  ParticularItem({var key, this.itemDetails, this.edit}):super(key: key);

  @override
  _ParticularItemState createState() => _ParticularItemState();
}

class _ParticularItemState extends State<ParticularItem> {
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  var itemDetails;
  int quantity = 1;
  bool editProduct;
  String image,name;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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

  editItemDetails(){
    Map<String,dynamic> args = widget.itemDetails;
    print(args);
    setState(() {
      editProduct = true;
      itemDetails = args['itemDetails'];
      quantity = args['itemDetails']['quantity'];
    });

  }

  setItemDetails(){
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black)
    );
    Map<String,dynamic> args = widget.itemDetails;
    setState(() {
      if(!widget.edit){
        editProduct = false;
        itemDetails = args;
      }
      else{
        editItemDetails();
      }
    });
  }

  addToShoppingBag() async{
    Loader.showLoadingScreen(context, keyLoader);
    CartService _shoppingBagService = new CartService();
    String msg = await _shoppingBagService.add(itemDetails['productId'],quantity);
    Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
    showInSnackBar(msg,Colors.black);
  }

  checkoutProduct(){
    Map<String,dynamic> args = new Map<String, dynamic>();
    args['price'] = itemDetails['price'];
    args['productId'] = itemDetails['productId'];
    args['quantity'] = quantity;
    Navigator.of(context).pushNamed('/checkout/address',arguments: args);
  }

  setQuantity(String type){
    setState(() {
      if(type == 'inc'){
        if(quantity != 5){
          quantity = quantity + 1;
        }
      }
      else{
        if(quantity != 1){
          quantity = quantity - 1;
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    setItemDetails();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 29
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: CustomProductImage(
                          itemDetails['image'],
                          buildContext,
                          editProduct,
                          itemDetails['productId'],
                          showInSnackBar
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                itemDetails['name'],
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 7.0),
                              Text(
                                "\$ ${itemDetails['price']}.00",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Center(
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      fontFamily: 'NovaSquare'
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: (){
                                      setQuantity('inc');
                                    },
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.add,
                                      size: 30.0,
                                    ),
                                    padding: EdgeInsets.all(12.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: (){
                                      setQuantity('dec');
                                    },
                                    textColor: Colors.white,
                                    color: Colors.black,
                                    child: Icon(
                                        Icons.remove,
                                        size: 30.0
                                    ),
                                    padding: EdgeInsets.all(12.0),
                                    shape: CircleBorder(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Divider(
                                  color: Colors.black
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: (MediaQuery.of(context).size.width - 30.0 - 10.0) /2,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 20.0),
                                      color: Colors.black,
                                      child: Text(
                                        'ADD TO BAG',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                      ),
                                      onPressed: (){
                                        addToShoppingBag();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  ButtonTheme(
                                    minWidth: (MediaQuery.of(context).size.width - 30.0 - 10.0) /2,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 20.0),
                                      color: Colors.white,
                                      child: Text(
                                        'Pay',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black
                                        ),
                                      ),
                                      onPressed: (){
                                        checkoutProduct();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}