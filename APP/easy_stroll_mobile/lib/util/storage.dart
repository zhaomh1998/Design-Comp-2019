import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FlutterSecureStorage getSecureStorage() => new FlutterSecureStorage();

void saveCredential(email, pswd, uid) async {
  final storage = getSecureStorage();
  try {
    await storage.write(key: "email", value: email);
    await storage.write(key: "pswd", value: pswd);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('doAutoLogin', true);
    } catch (e) {
      print("Caught error during storing config \'doAutoLogin\': $e");
    }
  } catch (e) {
    print("Caught error during storing emails and passwords $e");
  }
}

void saveLoc(LatLng pos) async {
  final storage = getSecureStorage();
  try {
    await storage.write(key: "lat", value: pos.latitude.toString());
    await storage.write(key: "lon", value: pos.longitude.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasStoredLocation', true);
  } catch (e) {
    print("Caught error during storing location: $e");
  }
}

Future<LatLng> loadLoc() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('hasStoredLocation') ?? false) {
    try {
      final storage = new FlutterSecureStorage();
      String latStr = await storage.read(key: "lat");
      String lonStr = await storage.read(key: "lon");
      return LatLng(double.parse(latStr), double.parse(lonStr));
    } catch (e) {
      print("Caught error during storing location: $e");
    }
  }
}
