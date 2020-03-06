import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Ordertile extends StatelessWidget {
  final String orderId;
  Ordertile(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('orders')
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              int status = snapshot.data['status'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Código do pedido: ${snapshot.data.documentID}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(_buildProductsText(snapshot.data)),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _builderCircle('1', 'Preparação', status, 1),
                      Icon(Icons.chevron_right, color: Colors.grey),
                      _builderCircle('2', 'Transporte', status, 2),
                      Icon(Icons.chevron_right, color: Colors.grey),
                      _builderCircle('3', 'Entrega', status, 3),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = 'Descrição:\n';
    for (LinkedHashMap p in snapshot.data['products']) {
      text +=
          '${p['quantity']} x ${p['product']['title']} (R\ ${p['product']['price'].toStringAsFixed(2)})\n';
    }
    text += 'Total: R\$ ${snapshot.data['totalPrice'].toStringAsFixed(2)}';
    return text;
  }

  Widget _builderCircle(
      String title, String subTitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blueAccent;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle),
      ],
    );
  }
}
