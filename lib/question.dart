import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionView extends StatefulWidget {
  final SocketIO socket;
  final String question;
  QuestionView(this.socket, this.question);

  @override
  State<StatefulWidget> createState() {
    return new QuestionContent(this.socket,this.question);
  }
}

class QuestionContent extends State<QuestionView> {
  final SocketIO socket;
  int _nbQuestions = 0;
  final String question;

  QuestionContent(this.socket, this.question);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(children: <Widget>[
          RichText(
              maxLines: 1,
              textAlign: TextAlign.center,
              text: TextSpan(style: TextStyle(fontSize: 40), children: [
                TextSpan(text: 'Question ' + _nbQuestions.toString()),
              ])),
          Center(
            child: RichText(
                maxLines: 1,
                textAlign: TextAlign.center,
                text: TextSpan(style: TextStyle(fontSize: 25), children: [
                  TextSpan(text: question),
                ])),
          ),
        ]));
  }
}
