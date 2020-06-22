import 'package:Separty/question.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Separty/register.dart';
import 'package:Separty/game.dart' as game;

class LobbyView extends StatefulWidget {
  static const routeName = '/lobby';
  final SocketIO socket;

  LobbyView(this.socket);

  @override
  State<StatefulWidget> createState() {
    return new LobbyContent(this.socket);
  }
}

class LobbyContent extends State<LobbyView> {
  final SocketIO socket;
  static ValueNotifier<bool> isInGameNotifier = ValueNotifier(false);
  /*static double progress;
  static ValueNotifier<double> progressNotifier = ValueNotifier(progress);*/

  LobbyContent(this.socket);
  /*void loading(){
    Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      progress+= 0.001;
    });
  }*/
  @override
  Widget build(BuildContext context) {
    User args = ModalRoute.of(context).settings.arguments;
    //progress = 0.0;
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
                body: Container(
                    alignment: Alignment.topCenter,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                          child: Image(
                              width: 250,
                              height: 100,
                              image: AssetImage('assets/images/logo.png'))),
                      ValueListenableBuilder(
                          valueListenable: isInGameNotifier,
                          builder: (BuildContext context, bool hasError,
                              Widget child) {
                            return Visibility(
                              maintainSize: false,
                              maintainState: false,
                              visible: !isInGameNotifier.value,
                              child: Column(
                                children: <Widget>[
                                  RichText(
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(fontSize: 40),
                                          children: [
                                            TextSpan(text: 'Game pin'),
                                          ])),
                                  StreamBuilder<int>(
                                      stream: game.pinStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snap) {
                                        return RichText(
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                style: TextStyle(fontSize: 40),
                                                children: [
                                                  TextSpan(
                                                      text: game.pin == null
                                                          ? ''
                                                          : game.pin
                                                              .toString()),
                                                ]));
                                      }),
                                ],
                              ),
                            );
                          }),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: ValueListenableBuilder(
                            valueListenable: isInGameNotifier,
                            builder: (BuildContext context, bool hasError,
                                Widget child) {
                              if (!isInGameNotifier.value) {
                                return StreamBuilder<List<String>>(
                                    stream: game.idsStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<String>> snap) {
                                      print(game.userIds);
                                      return Column(children: <Widget>[
                                        RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                                children: [
                                                  TextSpan(
                                                      text: game.userIds.length
                                                              .toString() +
                                                          '/4'),
                                                ])),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Container(
                                            height: 180,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: game.userIds
                                                    .map((userId) => userId
                                                            .isNotEmpty
                                                        ? RichText(
                                                            textAlign:
                                                                TextAlign.left,
                                                            text: TextSpan(
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        25),
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          userId),
                                                                ]))
                                                        : CircularProgressIndicator())
                                                    .toList())),
                                        /*ValueListenableBuilder(
                                          valueListenable: progressNotifier,
                                          builder: (BuildContext context,
                                              double error, Widget child) {
                                            loading();
                                            return Visibility(
                                              visible: !isInGameNotifier.value,
                                              maintainAnimation: true,
                                              maintainSize: true,
                                              maintainState: true,
                                              child: (LinearProgressIndicator(
                                                backgroundColor: Colors.purple,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.orange),
                                                value: progressNotifier.value,
                                              )),
                                            );
                                          },
                                        ),*/
                                      ]);
                                    });
                              } else {
                                return QuestionView(this.socket, game.question);
                              }
                            },
                          )),
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
      ),
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
                    this.socket.emit('leave', [
                      {'userId': u.uid, 'gamePin': game.pin}
                    ]);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
