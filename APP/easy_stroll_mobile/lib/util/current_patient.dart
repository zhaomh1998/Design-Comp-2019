// Stores current patient info
import 'package:google_maps_flutter/google_maps_flutter.dart';

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