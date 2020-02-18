import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstappferrovelho/datas/product_data.dart';

class CartProduct {

  String cid;
  String categoria;
  String pid;
  int quantity;
  String size;

  CartProduct();
  ProductData productData;

  CartProduct.fromDocument(DocumentSnapshot document){
      cid = document.documentID;
      categoria = document.data['category'];
      pid = document.data['pid'];
      quantity = document.data['quantity'];
      size = document.data['size'];
  }

  Map<String, dynamic> toMap(){
    return {
      'category': categoria,
      'pid': pid,
      'quantity' : quantity,
      'size': size,
      //'product' : productData.toResumeMap()
    };
  }


}