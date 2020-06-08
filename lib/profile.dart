// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:separtyapp/lobby.dart';

import 'login.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final String _username = args.name.substring(0, args.name.lastIndexOf('@'));
    final List<String> labels = [
      "Games played",
      "Games won",
      "Winrate",
      "Last played game"
    ];
    final List<String> values = ["10", "5", "50%", "07/06/2020"];

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/fond.jpg'),
                    fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(children: <Widget>[
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
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/logo.png'),
                                minRadius: 20,
                                maxRadius: 40,
                            )
                          ])),
                  SizedBox(
                    height: 40,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(style: TextStyle(fontSize: 20), children: [
                        TextSpan(text: 'User stats'),
                      ])),
                  Divider(
                    color: Colors.white,
                    thickness: 1.5,
                    indent: 80,
                    endIndent: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        ...getTextWidgets(labels, values),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                          indent: 60,
                          endIndent: 60,
                        ),
                        SizedBox(
                          height: 20,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LobbyView()),
                                );
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
                            onPressed: () {},
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                    children: [
                                      TextSpan(text: 'Join a game'),
                                    ])),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
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
                ]))));
  }
}

List<Widget> getTextWidgets(List<String> labels, List<String> values) {
  List<Widget> rows = new List<Widget>();
  for (int i = 0; i < labels.length; i++) {
    rows.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              style: TextStyle(fontSize: 20),
              children: [TextSpan(text: labels[i])]),
        ),
        RichText(
          textAlign: TextAlign.right,
          text: TextSpan(
              style: TextStyle(fontSize: 20),
              children: [TextSpan(text: values[i])]),
        )
      ],
    ));
    rows.add(new SizedBox(
      height: 20,
    ));
  }
  return rows;
}
