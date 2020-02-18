import 'package:firstappferrovelho/models/user_model.dart';
import 'package:firstappferrovelho/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },
            child: Text(
              "Criar conta",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            textColor: Colors.white,
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                validator: (text) {
                  if (text.isEmpty || !text.contains('@')) {
                    return "E-mail inválido!";
                  }
                },
                decoration: InputDecoration(hintText: "E-MAIL"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                validator: (text) {
                  if (text.isEmpty || text.length < 6) {
                    return "Senha Invalida";
                  }
                },
                decoration: InputDecoration(hintText: "SENHA"),
                obscureText: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Ensira um E-Mail para recuperação!"),
                        backgroundColor: Colors.redAccent[200],
                        duration: Duration(seconds: 2),
                      ));
                    }
                    if (!_emailController.text.contains("@")) {
                      model.recoverPass(_emailController.text);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("E-Mail invalido!"),
                        backgroundColor: Colors.redAccent[200],
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      model.recoverPass(_emailController.text);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Confira seu E-Mail!"),
                        backgroundColor: Colors.greenAccent,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: Text(
                    "esqueci minha senha",
                    textAlign: TextAlign.right,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      model.singIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSuccess: onSuccess,
                          onFail: onFail);
                    }
                  },
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void onSuccess() {
    Navigator.of(context).pop();
  }

  void onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao logar!!!"),
      backgroundColor: Colors.redAccent[200],
      duration: Duration(seconds: 2),
    ));
  }
}
