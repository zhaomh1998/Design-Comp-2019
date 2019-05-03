import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text("Easy Stroll Main Page Title")),
      body: new GoogleMaps(),
    );
  }
}

class GoogleMaps extends StatefulWidget {
  GoogleMaps({Key key}) : super(key: key);

  @override
  _GoogleMaps createState() => new _GoogleMaps();
}

class _GoogleMaps extends State<GoogleMaps> {
  GoogleMapController mapController;

  @override
  void initState() {
    // TODO: Init var stuff here ...
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //buildMap();
    var mq = MediaQuery.of(context);
    return Center(
      child: SizedBox(
        width: mq.size.width,
        height: mq.size.height,
//        child: Text("Hi")
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(0,0),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: LatLng(100, 100),
          tilt: 30.0,
          zoom: 17.0,
        ),
      ));
    });
  }
}
