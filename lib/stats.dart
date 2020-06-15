import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:separtyapp/register.dart';

class StatsView extends StatelessWidget {
  static const routeName = '/User';

  @override
  Widget build(BuildContext context) {
    User args = ModalRoute
        .of(context)
        .settings
        .arguments;
    List<String> _values = [];

    void setValue(User args) async {
      _values = await getValues(args);
    }

    setValue(args);

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
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover)),
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
                        text:
                        TextSpan(style: TextStyle(fontSize: 20), children: [
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
                              ...getTextWidgets(_labels, _values),
                              Divider(
                                color: Colors.white,
                                thickness: 1.5,
                                indent: 60,
                                endIndent: 60,
                              ),
                              SizedBox(
                                height: 40,
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
                                                color: Colors.white,
                                                fontSize: 20),
                                            children: [
                                              TextSpan(
                                                  text: 'Back to profile page'),
                                            ])),
                                  ))
                            ]))
                  ])))),
    );
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
    _values.add((_list['victories'] / _list['games']).toString());
    _values.add(_list['bestscore'].toString());
    _values.add(_list['lastgame'].toString());
    return _values;
  }
  return null;
}
