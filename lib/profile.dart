// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Separty/lobby.dart';
import 'package:Separty/register.dart';
import 'package:Separty/stats.dart';
import 'package:Separty/game.dart' as game;

class ProfileView extends StatefulWidget {
  static const routeName = '/profile';
  final SocketIO socket;
  static BuildContext buildContext;

  ProfileView(this.socket);

  @override
  State<StatefulWidget> createState() {
    return new ProfileContent(this.socket);
  }
}

class ProfileContent extends State<ProfileView> {
  bool _visibleText = false;
  File _image;
  bool gameExistence = true;
  final picker = ImagePicker();
  final SocketIO socket;

  ProfileContent(this.socket);

  void changeVisibility() {
    setState(() {
      _visibleText = !_visibleText;
    });
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
    final TextEditingController _pin = TextEditingController();
    ProfileView.buildContext = context;
    User args = ModalRoute.of(context).settings.arguments;

    void changeView(String s) {
      game.pin = int.parse(_pin.text.toString());
      this.socket.emit('join', [
        {'userId': args.uid, 'gamePin': int.parse(_pin.text.toString())}
      ]);
      Navigator.pushNamed(context, LobbyView.routeName, arguments: args);
    }

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover)),
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
                                  TextSpan(text: 'Welcome ' + args.username),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              height: 50,
                              width: 50,
                              child: GestureDetector(
                                  onTap: () async {
                                    await getImage();
                                    String str = await toBase64(_image);
                                    args.setProfilePic(str);
                                    ImageProvider avatar =
                                        await args.getProfilePic();
                                    setState(() {
                                      args.avatar = avatar;
                                    });
                                  },
                                  child: args.avatar == null
                                      ? CircleAvatar(
                                          radius: 55.0,
                                          backgroundColor: Colors.orange,
                                          child: CircularProgressIndicator(),
                                        )
                                      : CircleAvatar(
                                          radius: 55.0,
                                          backgroundColor: Colors.orange,
                                          backgroundImage: args.avatar,
                                        ))),
                          ButtonTheme(
                              child: RawMaterialButton(
                                  fillColor: Colors.orange,
                                  child: Icon(Icons.show_chart,
                                      color: Colors.white, size: 50),
                                  shape: CircleBorder(),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, StatsView.routeName,
                                        arguments: args);
                                  }))
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
                            this.socket.emit('create', [
                              {'userId': args.uid, 'questions': []}
                            ]);
                            // TODO : Move this code after whole game
                            args.lastgame = DateTime.now().toString();
                            args.updateData();
                            Navigator.pushNamed(context, LobbyView.routeName,
                                arguments: args);
                          },
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
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
        )));
  }
}
