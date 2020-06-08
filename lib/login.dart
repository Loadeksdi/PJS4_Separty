// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:separtyapp/profile.dart';
import 'package:separtyapp/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Separty';
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        routes: {
          ProfileView.routeName: (context) => ProfileView(),
        },
        title: appTitle,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fond.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                children: <Widget>[
                  Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        MyCustomForm(),
                      ])
                ],
              )),
        ));
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image(
                        width: 100,
                        height: 100,
                        image: AssetImage('assets/images/logo.png'))),
                TextFormField(
                  controller: _email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      labelText: 'E-mail address',
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.mail, color: Colors.white)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _password,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.lock, color: Colors.white)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (!validateStructure(value)) {
                      return 'Please enter a correct password.';
                    }
                    return null;
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: RaisedButton(
                      color: Colors.transparent,
                      textColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          login(_email.text.toString(),
                              _password.text.toString());
                        }
                      },
                      child: Text('Login'),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 20),
                        children: [
                          TextSpan(text: 'Don\'t have an account yet ?'),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    color: Colors.transparent,
                    textColor: Colors.white,
                    shape: ContinuousRectangleBorder(
                        side: BorderSide(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterView()),
                      );
                    },
                    child: Text('Sign up'),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(
          context,
          ProfileView.routeName,
          arguments: ScreenArguments(
            email
          )
      );
    } catch (error) {
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    "There is no user with such entries. Please try again.")));
          }
          break;
        case "ERROR_WRONG_PASSWORD":
          {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Your password is incorrect.")));
          }
          break;
        default:
          {}
      }
    }
  }
}

class ScreenArguments {
  final String name;

  ScreenArguments(this.name);
}
