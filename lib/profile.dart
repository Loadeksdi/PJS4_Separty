// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:separtyapp/lobby.dart';
import 'package:separtyapp/stats.dart';

import 'login.dart';

class ProfileView extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  State<StatefulWidget> createState() {
    return new ProfileContent();
  }
}

class ProfileContent extends State<ProfileView> {
  bool _visibleText = false;
  File _image;
  final picker = ImagePicker();

  void changeVisibility() {
    setState(() {
      _visibleText = !_visibleText;
    });
  }

  void changeView(String s) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LobbyView()),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<String> toBase64(File f) async {
    final bytes = await f.readAsBytes();
    return base64.encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final String _username = args.name.substring(0, args.name.lastIndexOf('@'));
    final TextEditingController _pin = TextEditingController();

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontSize: 20),
                            children: [
                              TextSpan(text: 'Welcome ' + _username),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          height: 50,
                          width: 50,
                          child: GestureDetector(
                            onTap: () {
                              getImage();
                              //TODO Call DB with : toBase64(_image);
                            },
                            child: CircleAvatar(
                                radius: 55.0,
                                backgroundColor: Colors.orange,
                                backgroundImage: _image == null
                                    ? AssetImage('assets/images/add_photo.png')
                                    : AssetImage(_image.path)),
                          )),
                      ButtonTheme(
                          child: RawMaterialButton(
                            fillColor: Colors.orange,
                            child: Icon(Icons.show_chart, color: Colors.white, size: 50),
                            shape: CircleBorder(),
                              onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StatsView()),
                        );
                      }
                      ))
                    ])),
            Center(
                child: Column(children: <Widget>[
              if (!_visibleText)
                ButtonTheme(
                    height: 50,
                    minWidth: 340,
                    child: RaisedButton(
                      color: Colors.transparent,
                      textColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LobbyView()),
                        );
                      },
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              children: [
                                TextSpan(text: 'Create a game'),
                              ])),
                    )),
              SizedBox(
                height: 15,
              ),
              ButtonTheme(
                height: 50,
                minWidth: 340,
                child: RaisedButton(
                  color: Colors.transparent,
                  textColor: Colors.white,
                  shape: ContinuousRectangleBorder(
                      side: BorderSide(color: Colors.white)),
                  onPressed: () {
                    changeVisibility();
                  },
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          children: [
                            TextSpan(text: 'Join a game'),
                          ])),
                ),
              ),
              if (_visibleText)
                Padding(
                    padding: EdgeInsets.fromLTRB(120, 20, 120, 0),
                    child: TextField(
                        controller: _pin,
                        onSubmitted: changeView,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLength: 4,
                        decoration: new InputDecoration(
                            labelText: "Game pin",
                            counterText: "",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            )),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                        ]))
            ])),
            Stack(alignment: Alignment.center, children: <Widget>[
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      children: [
                        TextSpan(text: 'Log out'),
                      ])),
              Opacity(
                  opacity: 0.0,
                  child: RawMaterialButton(onPressed: () {
                    Navigator.pop(context);
                  }))
            ])
          ],
        ),
      ),
    ));
  }
}
