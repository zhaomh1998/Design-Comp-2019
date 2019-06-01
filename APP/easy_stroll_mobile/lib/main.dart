import 'package:easy_stroll_mobile/ui/dev.dart';
import 'package:easy_stroll_mobile/ui/notification_manager.dart';
import 'package:easy_stroll_mobile/ui/signin.dart';
import 'package:easy_stroll_mobile/util/auth.dart';
import 'package:easy_stroll_mobile/util/var.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/map.dart';
import 'ui/walker_manager.dart';
import 'ui/analysis.dart';
import 'ui/menu.dart';
import 'util/uidata.dart';
import 'util/menu_bloc.dart';
import 'util/fcm.dart';
import 'ui/notification_manager.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final materialApp = MaterialApp(
      title: UIData.appName,
      theme: ThemeData(
          primaryColor: Colors.black,
          fontFamily: UIData.quickFont,
          primarySwatch: Colors.amber),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: HomePage(),
      // initialRoute: UIData.notFoundRoute,

      //routes
      routes: <String, WidgetBuilder>{
        '/map': (BuildContext context) => new MapPage(),
        '/walker' : (BuildContext context) => new WalkerManagerPage(),
        '/analysis' : (BuildContext context) => new AnalysisPage(),
        '/dev' : (BuildContext context) => new DevPage(),
        '/notification' : (BuildContext context) => new NotificationManagerPage(),
      },
  );

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}



class HomePage extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;
  //menuStack
  Widget menuStack(BuildContext context, Menu menu) => InkWell(
    onTap: () => _routeToPage(context, menu),
    splashColor: Colors.orange,
    child: Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          menuImage(menu),
          menuColor(),
          menuData(menu),
        ],
      ),
    ),
  );

  //appbar
  Widget appBar() => SliverAppBar(
    backgroundColor: Colors.black,
    pinned: true,
    elevation: 10.0,
    forceElevated: true,
    expandedHeight: 150.0,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: false,
      background: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: UIData.kitGradients)),
      ),
      title: Row(
        children: <Widget>[
          FlutterLogo(
            colors: Colors.yellow,
            textColor: Colors.white,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(UIData.appName)
        ],
      ),
    ),
  );

  //bodygrid
  Widget bodyGrid(List<Menu> menu) => SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount:
      MediaQuery.of(_context).orientation == Orientation.portrait
          ? 2
          : 3,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      childAspectRatio: 1.0,
    ),
    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return menuStack(context, menu[index]);
    }, childCount: menu.length),
  );

  Widget homeScaffold(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.transparent,
    ),
    child: Scaffold(key: _scaffoldState, body: bodySliverList()),
  );

  Widget bodySliverList() {
    MenuBloc menuBloc = MenuBloc();
    return StreamBuilder<List<Menu>>(
        stream: menuBloc.menuItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
            slivers: <Widget>[
              appBar(),
              bodyGrid(snapshot.data),
            ],
          )
              : Center(child: CircularProgressIndicator());
        });
  }


  void _routeToPage(BuildContext context, Menu menu) {
    Navigator.of(context).pushNamed(menu.routeName);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    configureFCM(globalFCM, context);
    return homeScaffold(context);
  }

  void _registerMessage(Map<String, dynamic> message) {
    print(message['data']['walkerId']);
    lastSOSWalkerId = message['data']['walkerId'];
    lastSOSTime = DateTime.now().millisecondsSinceEpoch;
  }

  void configureFCM(FirebaseMessaging fcm, BuildContext context) {
    fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    fcm.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        _registerMessage(message);
        Navigator.of(context).pushNamed('/notification');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        _registerMessage(message);
        Navigator.of(context).pushNamed('/notification');
      },
//      onLaunch: (Map<String, dynamic> message) {
//        print('on launch $message');
////        Navigator.of(context).pushNamed('/analysis');
//      },
    );



    fcm.subscribeToTopic('all');
  }

}