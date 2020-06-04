// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Separty Login';
    return MaterialApp(
        title: appTitle,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fond.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  MyCustomForm(),
                ]),
          ),
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
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              obscureText: true,
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
            RaisedButton(
              color: Colors.transparent,
              textColor: Colors.white,
              shape: ContinuousRectangleBorder(
                  side: BorderSide(color: Colors.white)),
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Login'),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20),
                children: [
                  TextSpan(text: 'Don\'t have an account yet ?'),
                ],
              ),
            ),
            RaisedButton(
              color: Colors.transparent,
              textColor: Colors.white,
              shape: ContinuousRectangleBorder(
                  side: BorderSide(color: Colors.white)),
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
