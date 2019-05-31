import 'package:flutter/material.dart';
import 'ui/map.dart';
import 'ui/signin.dart';
import 'ui/walker_manager.dart';
import 'ui/analysis.dart';
import 'util/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'util/db.dart';
import 'util/storage.dart';
import 'util/var.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'util/fcm.dart';

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
      routes: <String, WidgetBuilder> {
        '/map': (BuildContext context) => new MapPage(),
        '/walker' : (BuildContext context) => new WalkerManagerPage(),
        '/analysis' : (BuildContext context) => new AnalysisPage(),
      },
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
//  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String _message = "";
  @override
  initState() {
    super.initState();
    configureFCM(globalFCM);
    _login(context);
  }

  void configureFCM(FirebaseMessaging fcm) {
    fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    fcm.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        Navigator.of(context).pushNamed('/analysis');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        Navigator.of(context).pushNamed('/analysis');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        Navigator.of(context).pushNamed('/analysis');
      },
    );

    fcm.subscribeToTopic('all');
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
                    child: const Text('Walker Manager'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new WalkerManagerPage()));
                    },
                  ), // Walker Manager Page
                  RaisedButton(
                    child: const Text('Clear auto login'),
                    onPressed: () {_clearAutoLogin();},
                  ), // Clear Auto Log In
                  RaisedButton(
                    child: const Text('Get DB'),
                    onPressed: () {_testGetDB();},
                  ), // Test get DB all
                  RaisedButton(
                    child: const Text('Get Pos from DB'),
                    onPressed: () {_testGetPos();},
                  ), // Test get Pos
                  RaisedButton(
                    child: const Text('Get Pos from Storage'),
                    onPressed: () {_testGetSavedPos();},
                  ), // Test get Pos
                  RaisedButton(
                    child: const Text('Get uid from program'),
                    onPressed: () {setState(() {
                      _message = getUserId();
                    });},
                  ), // Display uid
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
      setUserId(uid);
      setState(() {
        _message = "Signed In with id: $uid";
      });
    }
    else {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new LoginSignUpPage(fbAuth)
          )
      );
    }
  }

  _clearAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doAutoLogin', false);
  }
  _testGetDB() async {
    DB db = getDB();
    Map db_data = await db.getWalkersData();
    setState(() {
      _message = "done";
    });
  }
  _testGetPos() async {
    DB db = getDB();
    var pos = await db.getLastPos('8944501810180175785f');
    saveLoc(pos);
    setState(() {
      _message = pos.toString();
    });
  }
  _testGetSavedPos() async {
    var pos = await loadLoc();
    setState(() {
      _message = pos.toString();
    });
  }
}



