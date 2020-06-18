import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Separty/register.dart';
import 'package:Separty/game.dart' as game;

class LobbyView extends StatefulWidget {
  static const routeName = '/lobby';

  @override
  State<StatefulWidget> createState() {
    return new LobbyContent();
  }
}

class LobbyContent extends State<LobbyView> {
  List<String> _userNames = [];

  @override
  Widget build(BuildContext context) {
    User args = ModalRoute.of(context).settings.arguments;
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
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        text:
                            TextSpan(style: TextStyle(fontSize: 40), children: [
                          TextSpan(text: 'Game pin'),
                        ])),
                    StreamBuilder<int>(
                        stream: game.pinStream,
                        builder:
                            (BuildContext context, AsyncSnapshot<int> snap) {
                          if(snap.hasData) {
                            return RichText(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                text:
                                TextSpan(style: TextStyle(fontSize: 40), children: [
                                  TextSpan(text:snap.data.toString()),
                                ]));
                          }
                          else {
                            return CircularProgressIndicator();
                          }
                        }),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          runAlignment: WrapAlignment.spaceEvenly,
                          children: <Widget>[]),
                    ),
                    ButtonTheme(
                      child: RaisedButton(
                        color: Colors.transparent,
                        onPressed: () {
                          _showDialog(context, args);
                        },
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

  void _showDialog(BuildContext context, User u) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
        });
  }

  void _showErrorDialog(BuildContext context, String s) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Incorrect PIN'),
            content: Text(s),
            actions: [
              FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  List<Widget> getSquaresWidgets() {
    return game.userIds.map((e) {
      print(e);
      return GestureDetector(
          child: Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                color: Colors.white,
                /*
                image: DecorationImage(
                    image:
                        Image.memory(base64Decode(usersProfilePics[i])).image,
                    fit: BoxFit.cover),
                */
              ),
              child: Text(e)),
          onTap: () {});
    }).toList();
  }
}
