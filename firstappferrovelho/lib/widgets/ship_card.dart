import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Digite seu CEP',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.green[500],
          ),
        ),
        leading: Icon(Icons.location_on),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Calcular frete",
              ),
              initialValue:  "",
              onFieldSubmitted: (text) {
              },
            ),
          )
        ],
      ),
    );
  }
}