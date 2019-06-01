import 'package:easy_stroll_mobile/ui/signin.dart';
import 'package:easy_stroll_mobile/util/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db.dart';
import 'api_key.dart';  // Create a dart file 'api_key.dart' in this folder
                        // Then write String GMAP_API_KEY = 'XX';
import 'package:google_maps_webservice/geocoding.dart';
import 'fcm.dart';

// User auth stuff
String _userId;

bool userLoggedIn() => _userId != null;

void setUserId(String uid) => _userId = uid;

String getUserId() => _userId;


// DB stuff
DB _db;
bool waitingUserLogin = false;
Future<DB> getDB(BuildContext context) async {
  if(_db != null)
    return _db;
  while(!userLoggedIn()) {
    waitingUserLogin = true;
    _login(context);
    while(waitingUserLogin) {
      await Future.delayed(Duration(milliseconds: 200));
    }
  }
  _db = EasyStrollDB(_userId);
  return _db;

}

_login(context) async {
  Auth fbAuth = new Auth();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool autoLogin = prefs.getBool('doAutoLogin') ?? false;
  if(autoLogin) {
    String uid = await fbAuth.autoSignIn();
    setUserId(uid);
    waitingUserLogin = false;
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


// Walker stuff
String _currentWalkerIndex;
List<Map> _allWaker = [];
Set<String> _allWalkerIds = {};

void updateWalkers(List<String> aWalkerList) {
  aWalkerList.forEach((walkerId) {
    if(!_allWalkerIds.contains(walkerId)) {
      _allWalkerIds.add(walkerId);
      notificationSubscribe(walkerId);
    }
  });
}

// Gmap services stuff
GoogleMapsGeocoding getGeoCoding() => new GoogleMapsGeocoding(apiKey: GMAP_API_KEY);