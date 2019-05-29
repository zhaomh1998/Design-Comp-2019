// Stores current patient info
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';


String patientName;
Map patientData;

void setPatient(String aName, Map aDataMap) {
  patientName = aName;
  patientData = aDataMap;
}

LatLng getLatestLoc() {
  LatLng latestLocation = new LatLng(patientData['lat'], patientData['lon']);
  return latestLocation;
}


String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' day ago';
    } else {
      time = diff.inDays.toString() + ' days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' week ago';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' weeks ago';
    }
  }

  return time;
}