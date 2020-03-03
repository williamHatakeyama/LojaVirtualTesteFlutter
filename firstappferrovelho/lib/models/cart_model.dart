import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstappferrovelho/datas/cart_product.dart';
import 'package:firstappferrovelho/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  bool isLoading = false;
  List<CartProduct> products = [];
  String totalValor;
  String coupomCode;
  int discountPercentage = 0;
  bool itemStatus = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItem();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  CartProduct validaItemCarrinho(CartProduct cartProduct) {
    for (CartProduct i in products) {
      if (i.pid == cartProduct.pid) {
        print("encontrou"+Timestamp.now().toString());
        return i;
      }
    }
    print("nao encontrou"+Timestamp.now().toString());
    return null;
  }

  void addCartItem(CartProduct cartProduct) {
    CartProduct testee = validaItemCarrinho(cartProduct);
    if (testee!= null){
      print("ta cheio"+Timestamp.now().toString());
      cartProduct.cid = testee.cid;
      print(testee.cid +"aaaaaaaaaaaaaaaaaaaaaaaa");
      print(testee.quantity.toString() +"bbbbbbbbbbbbbbbbbbbbbbbb");
      incProduct(cartProduct);
      notifyListeners();
    } else {
      products.add(cartProduct);
      Firestore.instance
          .collection('users')
          .document(user.firebaseUser.uid)
          .collection('cart')
          .add(cartProduct.toMap())
          .then((doc) {
        cartProduct.cid = doc.documentID;
        updateProduct(cartProduct);
      });
      notifyListeners();
    }
  }

  void removerCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void updateProduct(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItem() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  String calcValorItem(CartProduct cartProduct) {
    var quantity = cartProduct.quantity;
    var valor = cartProduct.productData.price;
    totalValor = (quantity * valor).toString();
    String total1 = (quantity * valor).toString();
    notifyListeners();
    return total1;
  }

  void setCoupon(String couponCode, int discountPercetage) {
    this.coupomCode = couponCode;
    this.discountPercentage = discountPercetage;
  }

  double getProductsPrice() {
    double price = 0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrice() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();

    double productPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
        await Firestore.instance.collection('orders').add(
      {
        'clientId': user.firebaseUser.uid,
        'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productsPrice': productPrice,
        'discount': discount,
        'totalPrice': productPrice - discount + shipPrice,
        'status': 1
      },
    );

    await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('orders')
        .document(refOrder.documentID)
        .setData({
      'orderId': refOrder.documentID,
    });

    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();

    coupomCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    print(refOrder.documentID);
    return refOrder.documentID;
  }
}
