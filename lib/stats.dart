import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> _labels = [
      "Games played",
      "Games won",
      "Winrate",
      "Last played game"
    ];
    final List<String> _values = ["10", "5", "50%", "07/06/2020"];

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
                    SizedBox(
                      height: 40,
                    ),
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
                                height: 20,
                              ),
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
