import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Separty/register.dart';

class StatsView extends StatefulWidget {
  static const routeName = '/stats';

  @override
  State<StatefulWidget> createState() {
    return new StatsContent();
  }
}

class StatsContent extends State<StatsView> {
  @override
  Widget build(BuildContext context) {
    User args = ModalRoute.of(context).settings.arguments;

    List<String> _values = ["", "", "", "", ""];

    void setValue() async {
      _values = await getValues(args);
    }

    setValue();
    final List<String> _labels = [
      "Games played",
      "Games won",
      "Winrate",
      "Best score",
      "Last played game"
    ];

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              alignment: Alignment.topCenter,
              child: Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 40),
                    child: Image(
                        width: 250,
                        height: 100,
                        image: AssetImage('assets/images/logo.png'))),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: TextStyle(fontSize: 20), children: [
                      TextSpan(text: 'Your stats'),
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
                          FutureBuilder(
                              future: getValues(args),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _labels[0])
                                            ]),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.right,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _values[0])
                                            ]),
                                      )
                                    ],
                                  );
                                } else {
                                  return CircularProgressIndicator(
                                    strokeWidth: 5,
                                  );
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                              future: getValues(args),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _labels[1])
                                            ]),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.right,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _values[1])
                                            ]),
                                      )
                                    ],
                                  );
                                } else {
                                  return CircularProgressIndicator(
                                    strokeWidth: 5,
                                  );
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                              future: getValues(args),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _labels[2])
                                            ]),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.right,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _values[2])
                                            ]),
                                      )
                                    ],
                                  );
                                } else {
                                  return CircularProgressIndicator(
                                    strokeWidth: 5,
                                  );
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                              future: getValues(args),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _labels[3])
                                            ]),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.right,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _values[3])
                                            ]),
                                      )
                                    ],
                                  );
                                } else {
                                  return CircularProgressIndicator(
                                    strokeWidth: 5,
                                  );
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                              future: getValues(args),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _labels[4])
                                            ]),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.right,
                                        text: TextSpan(
                                            style: TextStyle(fontSize: 20),
                                            children: [
                                              TextSpan(text: _values[4])
                                            ]),
                                      )
                                    ],
                                  );
                                } else {
                                  return CircularProgressIndicator(
                                    strokeWidth: 5,
                                  );
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.5,
                            indent: 60,
                            endIndent: 60,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ButtonTheme(
                              buttonColor: Colors.transparent,
                              shape: ContinuousRectangleBorder(
                                  side: BorderSide(color: Colors.white)),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        children: [
                                          TextSpan(
                                              text: 'Back to profile page'),
                                        ])),
                              ))
                        ]))
              ]))),
    ));
  }
}

Future<List<String>> getValues(args) async {
  List<String> _values = [];
  final _db = FirebaseDatabase.instance;
  DataSnapshot user = await _db
      .reference()
      .child('Users')
      .orderByChild('username')
      .equalTo(args.username)
      .once();
  if (user.value != null) {
    Map<String, dynamic> json = Map.from(user.value);
    var _list = json.values.elementAt(0);
    _values.add(_list['games'].toString());
    _values.add(_list['victories'].toString());
    if ((_list['victories'] / _list['games']).toString() == 'NaN') {
      _values.add('-');
    } else {
      _values.add((((_list['victories'] / _list['games'])*100).toString() + '%'));
    }
    _values.add(_list['bestscore'].toString());
    if (_list['lastgame'].toString() == '' ||
        _list['lastgame'] == null) {
      _values.add('-');
    } else {
      _values.add(_list['lastgame'].toString().substring(0, 10));
    }
    return _values;
  }
  return null;
}
