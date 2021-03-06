import 'package:firstappferrovelho/screens/cart_screen.dart';
import 'package:firstappferrovelho/tabs/Home_Tab.dart';
import 'package:firstappferrovelho/tabs/Orders_tab.dart';
import 'package:firstappferrovelho/tabs/Products_Tab.dart';
import 'package:firstappferrovelho/tabs/places_tab.dart';
import 'package:firstappferrovelho/widgets/cart_button.dart';
import 'package:firstappferrovelho/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrderTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
