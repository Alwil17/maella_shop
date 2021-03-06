import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maella_shop/services/userService.dart';

class CartService{
  UserService userService = new UserService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> update(String productId, int quantity, QuerySnapshot bagItems) async{
    String documentId;
    String msg;
    List productItems = bagItems.docs.map((doc){
      documentId = doc.id;
      return doc['products'];
    }).toList()[0];
    List product = productItems.where((test)=> test['id'] == productId).toList();
    if(product.length != 0){
      productItems.forEach((items){
        if(items['id'] == productId){
          items['quantity'] = quantity;
        }
      });
      msg =  "Panier mis a jour";
    }
    else{
      productItems.add({'id':productId,'quantity':quantity});
      msg = 'Produit ajoute au panier avec succes';
    }
    await _firestore.collection('bags').doc(documentId).set({'products':productItems});
    return msg;
  }

  Future<String> add(String productId,int quantity) async{
    String uid = await userService.getUserId();
    String msg;
    QuerySnapshot data = await _firestore.collection('bags').where("userId", isEqualTo: uid).get();
    if(data.docs.length == 0){
      await _firestore.collection('bags').add({
        'userId': uid,
        'products':[{
          'id': productId,
          'quantity': quantity
        }]
      });
      msg =  "Produit ajoute au panier avec succes";
    }
    else{
      msg = await update(productId, quantity, data);
    }
    return msg;
  }

  Future<List> list() async{
    List bagItemsList = new List();
    List itemDetails ;
    List productIdList =  new List(0);
    String uid = await userService.getUserId();

    QuerySnapshot docRef = await _firestore.collection('bags').where("userId",isEqualTo: uid).get();
    int itemLength = docRef.docs.length;
    if(itemLength != 0){
      itemDetails = docRef.docs.map((doc){
        return doc.data()['products'];
      }).toList()[0];
      productIdList = itemDetails.map((value) => value['id']).toList();
    }

    for(int i=0;i< productIdList.length;i++){
      Map mapProduct = new Map();
      DocumentSnapshot productRef = await _firestore.collection('products').doc(productIdList[i]).get();
      mapProduct['id'] = productRef.id;
      mapProduct['name'] = productRef.data()['name'];
      mapProduct['image'] = productRef.data()['image'][0];
      mapProduct['price']  = productRef.data()['price'].toString();
      mapProduct['quantity'] = itemDetails[i]['quantity'];
      bagItemsList.add(mapProduct);
    }
    return bagItemsList;
  }

  Future<void> remove(String id) async{
    String uid = await userService.getUserId();

    await _firestore.collection('bags').where('userId',isEqualTo: uid).get().then((QuerySnapshot doc){
      doc.docs.forEach((docRef) async{
        List products = docRef['products'];
        if(products.length == 1){
          await _firestore.collection('bags').doc(docRef.id).delete();
        }
        else{
          products.removeWhere((productData) => productData['id'] == id);
          await _firestore.collection('bags').doc(docRef.id).set({'products':products});
        }
      });
    });
  }

  Future<void> delete() async{
    String uid = await userService.getUserId();

    QuerySnapshot bagItems = await _firestore.collection('bags').where('userId',isEqualTo: uid).get();
    String shoppingBagItemId = bagItems.docs[0].id;

    final TransactionHandler deleteTransaction = (Transaction tx) async{
      final DocumentSnapshot ds = await tx.get(_firestore.collection('bags').doc(shoppingBagItemId));
      await tx.delete(ds.reference);
    };

    await _firestore.runTransaction(deleteTransaction);
  }
}