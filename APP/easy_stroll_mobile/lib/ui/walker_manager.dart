import 'package:easy_stroll_mobile/util/db.dart';
import 'package:flutter/material.dart';
import '../util/var.dart';
import '../util/current_patient.dart';

class WalkerManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WalkerManagerPageState();
  }
}

class _WalkerManagerPageState extends State<WalkerManagerPage> {
  bool _isLoading = true;
  List<Widget> walkerCards = [];

  @override
  void initState() {
    _loadData().then((data) {
      if(data == null) {
        setState(() {
          _isLoading = false;
        });
      }
      else {
      setState(() {
        data.forEach((k, v) {walkerCards.add(_buildCard(k, v, context));});
        print("Added card");
        _isLoading = false;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Patient")),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Add walker");
        },
        tooltip: 'Add walker',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(context) {
//    return Text("Walker Info Cards\nChoose which walker to display\nadd delete and stuff");
    return Stack(
      children: <Widget>[
        _buildLoading(),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if(_isLoading)
      return Container();
    if(walkerCards.isEmpty)
      return Center(child: Text("No walker registeded in this account."));
    else
      return ListView(children: walkerCards);
  }

  Widget _buildLoading() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0, width: 0.0,);
  }
}

Future<Map> _loadData() async {
  DB db = getDB();
  var walkerData = await db.getWalkersData();
  return walkerData;
}

//Widget _buildCard(String ccid, Map dataMap) {
//  String walkerName = dataMap['name'];
//  var latestData = dataMap;
//  int updatedTime = int.parse(latestData['time']);
////  double latestLat = latestData['lat'];
////  double latestLon = latestData['lon'];
//  return Card(
//    child: Padding(
//      padding: const EdgeInsets.all(12.0),
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          ListTile(
//            leading: Icon(Icons.shopping_cart),
//            title: Text(walkerName),
//            subtitle: Text(dataMap['addr'] + '\n' + "Last seen ${readTimestamp(updatedTime)}"),
//          ),
//          ButtonTheme.bar( // make buttons use the appropriate styles for cards
//            child: ButtonBar(
//              children: <Widget>[
//                FlatButton(
//                  child: const Text('View activity'),
//                  onPressed: () {
//                    print("Setting $walkerName as current patient");
//                    setPatient(walkerName, latestData);
//                  },
//                ),
//                IconButton(icon: Icon(Icons.settings), onPressed: () {},),
//              ],
//            ),
//          ),
//        ],
//      ),
//    ),
//  );
//}
Widget _buildCard(String ccid, Map dataMap, BuildContext context) {
  String walkerName = dataMap['name'];
  var latestData = dataMap;
  int updatedTime = int.parse(latestData['time']);
//  double latestLat = latestData['lat'];
//  double latestLon = latestData['lon'];
  return Card(
    color: Color(0xFFBDFFB6),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(walkerName, style: TextStyle(fontSize: 20.0),),
              Text(dataMap['addr'], style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
              Text("Last seen ${readTimestamp(updatedTime)}", style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic))
            ],
          ),
          IconButton(icon: Icon(Icons.play_arrow, size: 35.0,),
            onPressed: () {
              setPatient(walkerName, latestData);
              Navigator.of(context).pushNamed('/map');
            },)
        ],
      ),
    ),
  );
}