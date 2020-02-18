import 'package:firstappferrovelho/models/user_model.dart';
import 'package:firstappferrovelho/screens/login_screen.dart';
import 'package:firstappferrovelho/tiles/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 224, 234, 252),
                Color.fromARGB(255, 207, 222, 243),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, right: 5, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Flutter's \nCodex",
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                            print(model.isLoggedIn());
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Olá, ${!model.isLoggedIn() ? "" : model.userData['name']}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              child: Text(
                                model.isLoggedIn()
                                    ? 'Sair'
                                    : "entre ou cadastre-se >",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                if (!model.isLoggedIn()) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                                }else 
                                  model.signOut();
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Inicio", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
