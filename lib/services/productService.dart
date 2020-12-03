import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maella_shop/services/userService.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _productReference = FirebaseFirestore.instance.collection('products');
  CollectionReference _categoryReference = FirebaseFirestore.instance.collection('category');
  UserService _userService = new UserService();
  List subCategoryList = List();
  
  Future<Map> subcategoriesList(String category) async{
    QuerySnapshot categoryRef = await _categoryReference.where('categoryName', isEqualTo: category).get();
    Map<String,String> subCategory = new Map();
    for(Map ref in categoryRef.docs[0].data()['subCategory']){
      subCategory[ref['subCategoryName']] = ref['image'];
    }
    return subCategory;
  }

  Future<List> newItems() async{
    List<Map<String,String>> itemList = new List();
    QuerySnapshot itemRef = await _productReference.orderBy('name').get();
    for(DocumentSnapshot docReference in itemRef.docs){
      Map<String,String> items = new Map();
      items['image'] = docReference.data()['image'][0];
      items['name'] = docReference.data()['name'];
      items['productId'] = docReference.id;
      itemList.add(items);
    }
  }
  Future <List> featuredItems() async{
    List<Map<String,String>> itemList = new List();
    QuerySnapshot itemsRef = await _productReference.limit(15).get();
    for(DocumentSnapshot docRef in itemsRef.docs){
      Map<String,String> items = new Map();
      items['image'] = docRef.data()['image'][0];
      items['name'] = docRef.data()['name'];
      items['price'] = docRef.data()['price'].toString();
      items['productId'] = docRef.id;
      itemList.add(items);
    }
    return itemList;
  }
  Future<Map> particularItem(String productId) async{
    DocumentSnapshot prodRef = await _productReference.doc(productId).get();
    Map<String, dynamic> itemDetail = new Map();
    itemDetail['image'] = prodRef.data()['image'][0];
    itemDetail['price'] = prodRef.data()['price'];
    itemDetail['name'] = prodRef.data()['name'];
    itemDetail['productId'] = productId;
    return itemDetail;
  }

  Future <List> subCategoryItemsList(String subCategory) async{

    List<Map<String,String>> itemsList = new List();
    QuerySnapshot productRef = await _productReference.where("subCategory",isEqualTo: subCategory).get();
    for(DocumentSnapshot docRef in productRef.docs){
      Map<String,String> items  = new Map();
      items['image'] = docRef.data()['image'][0];
      items['name'] = docRef.data()['name'];
      items['price'] = docRef.data()['price'].toString();
      items['productId'] = docRef.id;
      itemsList.add(items);
    }
    return itemsList;
  }

  Future <List> categoriesList() async{
    QuerySnapshot _categoryRef = await _categoryReference.get();
    List <Map<String,String>> categoryList = new List();
    for(DocumentSnapshot dataRef in _categoryRef.docs){
      Map<String,String> category = new Map();
      category['categoryName'] = dataRef.data()['categoryName'];
      category['categoryImage'] = dataRef.data()['categoryImage'];
      categoryList.add(category);
    }
    return categoryList;
  }
  // ignore: missing_return
  Future <String> addItemToWishlist(String productId) async{
    String msg;
    String uid = await _userService.getUserId();
    List<dynamic> wishlist = new List<dynamic>();
    QuerySnapshot userRef = await _firestore.collection('users').where('userId',isEqualTo: uid).get();
    Map userData = userRef.docs[0].data();
    String documentId = userRef.docs[0].id;
    if(userData.containsKey('wishlist')){
      wishlist = userData['wishlist'];
      if(wishlist.indexOf(productId) == -1){
        wishlist.add(productId);
      }
      else{
        msg = 'Le produit existe deja dans la wishlist';
        return msg;
      }
    }
    else{
      wishlist.add(productId);
    }
    await _firestore.collection('users').doc(documentId).update({
      'wishlist': wishlist
    }).then((value){
      msg = 'Produit ajoute aux favoris';
      return msg;
    });
  }

}
class NewArrival{
  final String name;
  final String image;

  NewArrival({this.name, this.image});
}