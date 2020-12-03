import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maella_shop/component/items/bottomSheet.dart';
import 'package:maella_shop/pages/home.dart';
import 'package:maella_shop/services/productService.dart';
import 'customTransition.dart';


class CustomProductImage extends StatefulWidget {
  final String image;
  final BuildContext buildContext;
  final bool editProduct;
  final String productId;
  final void Function (String msg, Color color) showInSnackBar;

  CustomProductImage(
      this.image,
      this.buildContext,
      this.editProduct,
      this.productId,
      this.showInSnackBar
      );
  @override
  _CustomProductImageState createState() => _CustomProductImageState();
}

class _CustomProductImageState extends State<CustomProductImage> {
  ProductService _productService = new ProductService();

  addItemToWishlist() async{
    String msg = await _productService.addItemToWishlist(widget.productId);
    widget.showInSnackBar(msg,Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0)),
            image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.fill
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 42.0,
                      color: Colors.grey,
                    ),
                    onPressed: (){
                      Navigator.pop(
                          widget.buildContext,
                          CustomTransition(
                              type: CustomTransitionType.upToDown,
                              child: Home()
                          ));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 36.0,
                      color: Colors.grey,
                    ),
                    onPressed: (){
                      showModalBottomSheet(context: widget.buildContext, builder: (context){
                        return ShowBottomScreen();
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 25, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                textBaseline: TextBaseline.ideographic,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      addItemToWishlist();
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    shape: CircleBorder(),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            )
          ],
        )
    );
  }
}
