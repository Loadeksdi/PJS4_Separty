import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LobbyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fond.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                  alignment: Alignment.topCenter,
                  child: Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 40),
                        child: Image(
                            width: 100,
                            height: 100,
                            image: AssetImage('assets/images/logo.png'))),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(fontSize: 40),
                            children: [
                              TextSpan(text: 'Game pin \n'),
                              TextSpan(text: 'PIN')
                            ])),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          runAlignment: WrapAlignment.spaceEvenly,
                          children: <Widget>[
                            ...getSquaresWidgets()
                          ],
                        ))
                  ])))),
    );
  }
}

List<Widget> getSquaresWidgets() {
  List<Widget> squares = new List<Widget>();
  for (int i = 0; i < 4; i++) {
    squares.add(new ButtonTheme(
      child: RaisedButton(
        onPressed: (){

        },
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0)))),
      height: 120,
      minWidth: 120,
    ));
  }
  return squares;
}
