import 'package:flutter/material.dart';
import 'ui.dart';
import 'signin.dart';
import 'auth.dart';

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
                              builder: (context) => new MainPage()));
                    },
                  ),
                  RaisedButton(
                    child: const Text('TestAuth'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new LoginSignUpPage(auth: new Auth(), onSignedIn: () {debugPrint("SignedInWithID");},)
                        )
                      );
                    },
                  ), // Raised Button
                ], // Column
              ),
            ),
          ]),
        ));
  }
}
