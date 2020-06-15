// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:separtyapp/profile.dart';
import 'package:separtyapp/register.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:separtyapp/stats.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const routeName = '/User';

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
          StatsView.routeName: (context) => StatsView()
        },
        title: appTitle,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
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
  Widget _icon = Icon(Icons.person, color: Colors.white);

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
                        width: 250,
                        height: 100,
                        image: AssetImage('assets/images/logo.png'))),
                TextFormField(
                  controller: _email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      labelText: 'Username or email address',
                      labelStyle: TextStyle(color: Colors.white),
                      icon: _icon),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.contains('@')) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _icon = Icon(Icons.mail, color: Colors.white);
                        });
                      });
                    } else {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _icon = Icon(Icons.person, color: Colors.white);
                        });
                      });
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
                          login(_email.text.toString().trim(),
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
    User args = ModalRoute.of(context).settings.arguments;
    if (email.contains('@')) {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        if (args != null) {
          Navigator.pushNamed(context, ProfileView.routeName, arguments: args);
        } else {
          final _db = FirebaseDatabase.instance;
          _db
              .reference()
              .child('Users')
              .orderByChild('username')
              .equalTo(_email.text.toString().trim())
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              Map<String, dynamic> json = Map.from(snapshot.value);
              var _list = json.values.elementAt(0);
              String uid = json.keys.elementAt(0);
              String username = _list['username'];
              String profilepic = _list['profilepic'];
              User u = new User(uid, username, email, "", 0, 0, 0, null);
              u.setProfilePic(profilepic);
              Navigator.pushNamed(context, ProfileView.routeName, arguments: u);
            }
          });
        }
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
    } else {
      final _db = FirebaseDatabase.instance;
      _db
          .reference()
          .child('Users')
          .orderByChild('username')
          .equalTo(_email.text.toString().trim())
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<String, dynamic> json = Map.from(snapshot.value);
          var _list = json.values.elementAt(0);
          String newEmail = _list['email'];
          login(newEmail, password);
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid username.")));
        }
      });
    }
  }
}
