import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LobbyView extends StatelessWidget {
  static const routeName = '/lobby';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                  alignment: Alignment.topCenter,
                  child: Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: Image(
                            width: 250,
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
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          runAlignment: WrapAlignment.spaceEvenly,
                          children: <Widget>[...getSquaresWidgets()],
                        )),
                    ButtonTheme(
                      child: RaisedButton(
                        color: Colors.transparent,
                        onPressed: () {
                          _showDialog(context);},
                        shape: ContinuousRectangleBorder(
                            side: BorderSide(color: Colors.white)),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                children: [
                                  TextSpan(text: 'Leave game'),
                                ])),
                      ),
                    ),
                  ])))),
    );
  }
  void _showDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Leave game'),
            content: Text('Are you sure you want to leave ?'),
            actions: [
              FlatButton(
                child: Text("No"),
                onPressed: () {
                    Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ],
          );
        }
    );
  }
}

List<Widget> getSquaresWidgets() {
  List<Widget> squares = new List<Widget>();
  for (int i = 0; i < 4; i++) {
    squares.add(new ButtonTheme(
      child: RaisedButton(
          onPressed: () {},
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)))),
      height: 135,
      minWidth: 135,
    ));
  }
  return squares;
}





