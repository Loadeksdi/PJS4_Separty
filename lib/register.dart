// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
    child: new Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
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
    )));
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
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<String> register(
      String username, String email, String password) async {
    try {
      final FirebaseUser user = (await _firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      final dbUsers =
          FirebaseDatabase.instance.reference().child('Users').child(user.uid);

      dbUsers.set({
        'username': _username.text,
        'email': _email.text,
        'profilepic': "",
        'games': 0,
        'victories': 0,
        'bestscore': 0,
        'lastgame': ""
      });
      return user.uid;
    } catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('This email is already in use.')));
          }
          break;
        case "ERROR_WEAK_PASSWORD":
          {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('This password is too weak.')));
          }
          break;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return new WillPopScope(
        onWillPop: () async => false,
        child: new Form(
          autovalidate: true,
          key: _formKey,
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
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _username,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.person, color: Colors.white)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (!validCharacters.hasMatch(value)) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _email,
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
                    SizedBox(height: 5),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _pass,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.lock, color: Colors.white)),
                      validator: (valueFirst) {
                        if (valueFirst.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (!validateStructure(valueFirst)) {
                          return 'Please enter a correct password.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: _confirmPass,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.lock, color: Colors.white)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (!validateStructure(value)) {
                          return 'Please enter a correct password.';
                        }
                        if (_pass.text.toString() !=
                            _confirmPass.text.toString()) {
                          return 'The two passwords are different.';
                        }
                        return null;
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: RaisedButton(
                          color: Colors.transparent,
                          textColor: Colors.white,
                          shape: ContinuousRectangleBorder(
                              side: BorderSide(color: Colors.white)),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              String uid = await register(
                                  _username.text.toString(),
                                  _email.text.toString(),
                                  _confirmPass.text.toString());
                              User u = User(uid, _username.text.toString(),
                                  _email.text.toString(), "", 0, 0, 0, "");
                              Navigator.pop(context, u);
                            }
                          },
                          child: Text('Register'),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 20),
                            children: [
                              TextSpan(text: 'Already have an account ?'),
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
                          Navigator.pop(context);
                        },
                        child: Text('Login'),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}

class User {
  String uid;
  String username;
  String email;
  String profilepic;
  int games;
  int victories;
  int bestscore;
  String lastgame;
  ImageProvider avatar;

  User(this.uid, this.username, this.email, this.profilepic, this.games,
      this.victories, this.bestscore, this.lastgame);

  void setProfilePic(String s) async {
    this.profilepic = s;
    updateData();
    this.avatar = await getProfilePic();
  }

  void updateData() {
    final dbUsers =
        FirebaseDatabase.instance.reference().child('Users').child(this.uid);
    dbUsers.set({
      'username': this.username,
      'email': this.email,
      'profilepic': this.profilepic,
      'games': this.games,
      'victories': this.victories,
      'bestscore': this.bestscore,
      'lastgame': this.lastgame
    });
  }

  Future<ImageProvider> getProfilePic() async {
    final _db = FirebaseDatabase.instance;
    DataSnapshot user = await _db
        .reference()
        .child('Users')
        .orderByChild('username')
        .equalTo(this.username)
        .once();
    if (user.value != null) {
      Map<String, dynamic> json = Map.from(user.value);
      var _list = json.values.elementAt(0);
      String pp = _list['profilepic'];
      if (pp != null) {
        return Image.memory(base64Decode(pp)).image;
      }
    }
    return Image.asset('assets/images/add_photo.png').image;
  }
}
