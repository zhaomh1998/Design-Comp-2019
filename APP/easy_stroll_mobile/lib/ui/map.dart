import 'dart:io';

import 'package:easy_stroll_mobile/util/var.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../util/auth.dart';
import '../util/db.dart';
import '../util/current_patient.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageStates createState() => new _MapPageStates();
}

class _MapPageStates extends State<MapPage> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
//    _updateMapLoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$patientName's Activity")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: _buildGoogleMap(),),
        Expanded(child: _buildControl())
      ],
    );
}

  Widget _buildControl() {
    return ListView(
      children: <Widget>[
        InkWell(
          child: ListTile(
            leading: Icon(Icons.access_time),
            title: Text(readTimestamp(int.parse(patientData['time']))),
            subtitle: Text(patientData['addr']),
          ),
          onTap: ()=>print("Tap!"),
        ),
        InkWell(
          child: ListTile(
            leading: Icon(Icons.more_vert),
            title: Text("View More"),
            subtitle: Text("Click to load more histrical data"),
          ),
          onTap: ()=>_loadMoreData(context)
        ),
      ],
    );
  }
  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(32.88, -117.23),
        zoom: 12.0,
      ),
      markers: Set<Marker>.of(markers.values),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    _updateRecentPin(controller);
  }

  void _updateRecentPin(GoogleMapController controller) {
    addMarker("Latest", readTimestamp(int.parse(patientData['time'])), getLatestLoc());
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0.0,
        target: getLatestLoc(),
        tilt: 0.0,
        zoom: 18.0,
      ),
    ));
  }

  void _loadMoreData(BuildContext context) async {
    DB esDB = await getDB(context);
    List<Map> recentPos = await esDB.getRecentPos(patientData['ccid'], 100);
    recentPos.forEach((gpsSample) {
      print(gpsSample);
      setState(() {
        addMarker(gpsSample['time'], readTimestamp(int.parse(gpsSample['time'])), LatLng(gpsSample['lat'], gpsSample['lon']));
      });
    });
  }

  void addMarker(String anId, String anSubtitle, LatLng markerPosition) {
    final MarkerId markerId = MarkerId(anId);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: markerPosition,
      infoWindow: InfoWindow(title: markerId.value, snippet: anSubtitle),
//      onTap: () {
////        _onMarkerTapped(markerId);
////      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

//    DB db = new EasyStrollDB();
//    var pos = await db.getPos('8944501810180175785f');
//    saveLoc(pos);
//    setState(() {
//      _message = pos.toString();
//    });
  }

