import 'package:flutter/material.dart';
import 'ui/map.dart';
import 'ui/signin.dart';
import 'util/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Easy Stroll',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Easy Stroll Landing Page Title'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = "";
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: const Text('MainPage'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MapPage()));
                    },
                  ), // Map Page
                  RaisedButton(
                    child: const Text('LogIn'),
                    onPressed: () {_login(context);},
                  ), // Log In Page
                  RaisedButton(
                    child: const Text('Clear auto login'),
                    onPressed: () {_clearAutoLogin();},
                  ), // Clear Auto Log In
                  RaisedButton(
                    child: const Text('Clear msg'),
                    onPressed: () {setState(() {
                      _message = "";
                    });},
                  ), // Clear Msg
                ], // Column
              ),
            ),
            Text(_message), // Msg
          ]),
        ));
  }


  _login(context) async {
    Auth fbAuth = new Auth();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool autoLogin = prefs.getBool('doAutoLogin') ?? false;
    if(autoLogin) {
      String uid = await fbAuth.autoSignIn();
      setState(() {
        _message = "Signed In with id: $uid";
      });
    }
    else {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new LoginSignUpPage(auth: fbAuth, onSignedIn: () {debugPrint("SignedInWithID");},)
          )
      );
    }
//  await prefs.setInt('counter', counter);
  }

  _clearAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doAutoLogin', false);
  }
}

