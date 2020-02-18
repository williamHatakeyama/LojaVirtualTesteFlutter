import 'package:firstappferrovelho/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Nome Completo"),
                validator: (text) {
                  if (text.isEmpty) {
                    return "Nome invalido!";
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "E-Mail"),
                validator: (text) {
                  if (text.isEmpty || !text.contains("@")) {
                    return "E-Mail invalido!";
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Senha"),
                validator: (text) {
                  if (text.isEmpty || text.length < 6) {
                    return "Senha invalida!";
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(hintText: "Endereço"),
                validator: (text) {
                  if (text.isEmpty) {
                    return "Endereço invalido!";
                  }
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _addressController.text
                      };

                      model.signUp(
                        userData: userData,
                        pass: _passController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                      );
                    }
                  },
                  child: Text(
                    "Criar Conta",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuario criado com sucesso!!!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      return Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuario!!!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
