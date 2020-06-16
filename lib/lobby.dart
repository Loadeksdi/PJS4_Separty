import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:Separty/register.dart';

class LobbyView extends StatefulWidget {
  static const routeName = '/lobby';

  @override
  State<StatefulWidget> createState() {
    return new LobbyContent();
  }
}

class LobbyContent extends State<LobbyView> {
  int counterCreate = 0;
  int counterJoin = 0;
  final HttpsCallable callableCreateGame =
      CloudFunctions.instance.getHttpsCallable(
    functionName: 'createGame',
  )..timeout = const Duration(seconds: 30);

  final HttpsCallable callableJoinGame =
      CloudFunctions.instance.getHttpsCallable(
    functionName: 'joinGame',
  )..timeout = const Duration(seconds: 30);

  Future<String> createGame(User u) async {
    if (counterCreate == 0) {
      counterCreate++;
      dynamic resp =
          await callableCreateGame.call(<String, dynamic>{'uid': u.uid});
      return resp.data.toString();
    } else {
      return null;
    }
  }

  void joinGame(User u, int pin) async {
    if (counterJoin == 0) {
      counterJoin++;
      dynamic resp = await callableJoinGame
          .call(<String, dynamic>{'uid': u.uid, 'pin': pin});
    }
  }

  @override
  Widget build(BuildContext context) {
    User args = ModalRoute.of(context).settings.arguments;
    int pin = args.pin;

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
                          TextSpan(text: 'Game pin \n'),
                        ])),
                    (pin == null)
                        ? FutureBuilder(
                            future: createGame(args),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 40),
                                        children: [
                                          TextSpan(
                                              text: snapshot.data.toString()),
                                        ]));
                              } else {
                                return CircularProgressIndicator(
                                  strokeWidth: 1,
                                );
                              }
                            },
                          )
                        : Builder(
                            builder: (context) {
                              joinGame(args, pin);
                                return RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 40),
                                        children: [
                                          TextSpan(text: pin.toString()),
                                        ]));
                            },
                          ),
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
                          _showDialog(context);
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

  void _showDialog(BuildContext context) {
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
