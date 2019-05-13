import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DB {
  DB(String userId);

  Future<String> getAll(); // For test
  Future<LatLng> getLastPos(String ccid);

  Future<List<Map>> getRecentPos(String ccid, int retrieveEntries);
  Future<List<String>> getAssociateWalkers();
  Future<Map> getWalkersData();
}

class EasyStrollDB implements DB {
  String _uid;
  final databaseReference;

  EasyStrollDB(String userId)
      : _uid = userId,
        databaseReference = FirebaseDatabase.instance.reference() {
    assert (_uid != null, "Attempting to intialize DB with null userId!");
  }

  Future<String> getAll() async {
    DataSnapshot data = await databaseReference.once();
    return 'Data: ${data.value}';
  }

  @override
  Future<LatLng> getLastPos(String ccid) async {
    DataSnapshot data = await databaseReference
        .child('walker/$ccid/gps')
        .limitToLast(1)
        .once();
    double lat = data.value['lat'];
    double lon = data.value['lon'];
    return LatLng(lat, lon);
  }

  Future<List<Map>> getRecentPos(String ccid, int retrieveEntries) async {
    List<Map> returnPos = [];
    Future<DataSnapshot> data = databaseReference.child('walker/$ccid/gps')
        .limitToLast(retrieveEntries)
        .once();
    await data.then((snapshot) {
      snapshot.value.forEach((k, v) {
        var dataMap = {"time": k, "lat": v["lat"], "lon": v["lon"]};
        returnPos.add(dataMap);
      });
    });
    return returnPos;
  }

  Future<List<String>> getAssociateWalkers() async {
    DataSnapshot data = await databaseReference.child('client/$_uid/walker').once();
    List<String> walkerCCIDs = [];
    if(data.value!= null) {
      data.value.forEach((ccid) {
        walkerCCIDs.add(ccid);
      });
      return walkerCCIDs;
    }
    else {
      print("User: $_uid has no walker associated!");
      return null;
    }
  }

  Future<Map> getWalkersData() async {
    List<String> allWalkers = await getAssociateWalkers();
    Map<String, Map> walkersData = new HashMap();
    for (String walkerId in allWalkers) {
      Map walkerSnapshot;
      await getRecentPos(walkerId, 1).then((dataList) {
        walkerSnapshot = dataList.first;
      });
      walkersData[walkerId] = walkerSnapshot;
    }
    return walkersData;
  }
}
