// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:Separty/lobby.dart';
import 'package:Separty/profile.dart';
import 'package:Separty/register.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Separty/stats.dart';
import 'package:Separty/game.dart' as game;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SocketIOManager manager;
  SocketIO socket;
  bool connected;
  final GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    manager = SocketIOManager();
    connected = false;
    initSocket();
  }

  void initSocket() async {
    socket = await manager.createInstance(SocketOptions(
        'http://192.168.1.27:3000/',
        transports: [Transports.WEB_SOCKET]));
    socket.onConnect((data) {
      setState(() {
        connected = true;
      });
    });
    socket.on('create', (data) {
      print("awa");
      game.pinSc.add(data);
      game.pin = data;
    });
    socket.on('_error', (data) {
      game.pin = null;
      game.pinSc.add(null);
      if (data != null) {
        showDialog(
            context: ProfileView.buildContext,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Incorrect PIN : ' + data['code'].toString()),
                content: Text(data['error'].toString()),
                actions: [
                  FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(ProfileView.buildContext);
                      }),
                ],
              );
            });
      }
    });
    socket.on('join', (data) {
      print("uwu");
      game.pinSc.add(data.gamePin);
      game.pin = data.gamePin;
    });
    socket.on('newjoin', (data) {
      game.userIds = [...data.users];
      print("owo");
      setState(() {
        LobbyView.userNames = game.userIds;
      });
    });
    socket.on('leave', (data) {
      game.pinSc.add(null);
      game.pin = null;
    });
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Separty';
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        routes: {
          ProfileView.routeName: (context) => ProfileView(socket),
          StatsView.routeName: (context) => StatsView(),
          LobbyView.routeName: (context) => LobbyView(socket)
        },
        title: appTitle,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                children: <Widget>[
                  Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        MyCustomForm(connected),
                      ])
                ],
              )),
        ));
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  MyCustomForm(this.connected);

  bool connected;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(this.connected);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Widget _icon = Icon(Icons.person, color: Colors.white);

  bool connected;

  MyCustomFormState(this.connected);

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image(
                        width: 250,
                        height: 100,
                        image: AssetImage('assets/images/logo.png'))),
                TextFormField(
                  controller: _email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      labelText: 'Username or email address',
                      labelStyle: TextStyle(color: Colors.white),
                      icon: _icon),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.contains('@')) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _icon = Icon(Icons.mail, color: Colors.white);
                        });
                      });
                    } else {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _icon = Icon(Icons.person, color: Colors.white);
                        });
                      });
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _password,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.lock, color: Colors.white)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (!validateStructure(value)) {
                      return 'Please enter a correct password.';
                    }
                    return null;
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: RaisedButton(
                      color: Colors.transparent,
                      textColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          login(_email.text.toString().trim(),
                              _password.text.toString());
                        }
                      },
                      child: Text('Login'),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 20),
                        children: [
                          TextSpan(text: 'Don\'t have an account yet ?'),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    color: Colors.transparent,
                    textColor: Colors.white,
                    shape: ContinuousRectangleBorder(
                        side: BorderSide(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterView()),
                      );
                    },
                    child: Text('Sign up'),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void login(String email, String password) async {
    User args = ModalRoute.of(context).settings.arguments;
    if (email.contains('@')) {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        if (args != null) {
          Navigator.pushNamed(context, ProfileView.routeName, arguments: args);
        } else {
          final _db = FirebaseDatabase.instance;
          final DataSnapshot snapshot = await _db
              .reference()
              .child('Users')
              .orderByChild('email')
              .equalTo(email)
              .once();
          if (snapshot.value != null) {
            Map<String, dynamic> json = Map.from(snapshot.value);
            var _list = json.values.elementAt(0);
            String uid = json.keys.elementAt(0);
            String username = _list['username'];
            String profilepic = _list['profilepic'];
            int games = _list['games'];
            int victories = _list['victories'];
            int bestscore = _list['bestscore'];
            String lastgame = _list['lastgame'];
            User u = new User(uid, username, email, profilepic, games,
                victories, bestscore, lastgame);
            u.setProfilePic(profilepic);
            u.avatar = await u.getProfilePic();
            Navigator.pushNamed(context, ProfileView.routeName, arguments: u);
          }
        }
      } catch (error) {
        switch (error) {
          case "ERROR_USER_NOT_FOUND":
            {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "There is no user with such entries. Please try again.")));
            }
            break;
          case "ERROR_WRONG_PASSWORD":
            {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Your password is incorrect.")));
            }
            break;
          default:
            {}
        }
      }
    } else {
      final _db = FirebaseDatabase.instance;
      _db
          .reference()
          .child('Users')
          .orderByChild('username')
          .equalTo(_email.text.toString().trim())
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<String, dynamic> json = Map.from(snapshot.value);
          var _list = json.values.elementAt(0);
          String newEmail = _list['email'];
          login(newEmail, password);
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid username.")));
        }
      });
    }
  }
}
