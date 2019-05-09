import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> autoSignIn() async {
    final storage = new FlutterSecureStorage();
      String email = await storage.read(key: "email");
      String password = await storage.read(key: "pswd");
      String uid = await storage.read(key: "uid");
      return signIn(email, password);
  }
}


void saveCredential(email, pswd, uid) async {
  final storage = new FlutterSecureStorage();
  try {
    await storage.write(key: "email", value: email);
    await storage.write(key: "pswd", value: pswd);
    await storage.write(key: "uid", value: uid);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('doAutoLogin', true);
    }
    catch(e) {
      print("Caught error during storing config \'doAutoLogin\': $e");
    }
  }
  catch(e) {
    print("Caught error during storing emails and passwords $e");
  }
}

void saveLoc(LatLng pos) async {
  final storage = new FlutterSecureStorage();
  try {
    await storage.write(key: "lat", value: pos.latitude.toString());
    await storage.write(key: "lon", value: pos.longitude.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasStoredLocation', true);
  }
  catch(e) {
    print("Caught error during storing location: $e");
  }
}

Future<LatLng> loadLoc() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getBool('hasStoredLocation') ?? false) {
    try {
      final storage = new FlutterSecureStorage();
      String latStr = await storage.read(key: "lat");
      String lonStr = await storage.read(key: "lon");
      return LatLng(double.parse(latStr), double.parse(lonStr));
    }
    catch(e) {
      print("Caught error during storing location: $e");
    }
  }

}