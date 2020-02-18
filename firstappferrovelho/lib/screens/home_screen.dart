import 'package:firstappferrovelho/tabs/Home_Tab.dart';
import 'package:firstappferrovelho/tabs/Products_Tab.dart';
import 'package:firstappferrovelho/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      // physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
      ],
    );
  }
}
