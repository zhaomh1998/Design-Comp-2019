import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../util/auth.dart';
import '../util/db.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageStates createState() => new _MapPageStates();
}

class _MapPageStates extends State<MapPage> {
  GoogleMapController mapController;
  LatLng _loc = LatLng(0,0);
  @override
  void initState() {
    _updateMapLoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Easy Stroll Map Page Title")),
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
      children: <Widget>[Text(_loc.toString())],
    );
  }
  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(32.88, -117.23),
        zoom: 12.0,
      ),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
//      mapController.animateCamera(CameraUpdate.newCameraPosition(
//        CameraPosition(
//          bearing: 0.0,
//          target: _loc,
//          tilt: 0.0,
//          zoom: 18.0,
//        ),
//      )
//      );
    });
  }

  Future<void> _updateMapLoc() async {
//    var pos = await loadLoc();
    EasyStrollDB db = new EasyStrollDB();
    var pos = await db.getPos('8944501810180175785f');
    setState(() {
      _loc = pos;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: pos,
          tilt: 0.0,
          zoom: 18.0,
        ),
      )
      );
    });
//    EasyStrollDB db = new EasyStrollDB();
//    var pos = await db.getPos('8944501810180175785f');
//    saveLoc(pos);
//    setState(() {
//      _message = pos.toString();
//    });
  }
}

