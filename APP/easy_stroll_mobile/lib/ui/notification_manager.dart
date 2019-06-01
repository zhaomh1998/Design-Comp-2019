import 'package:easy_stroll_mobile/util/db.dart';
import 'package:flutter/material.dart';
import '../util/var.dart';
import '../util/current_patient.dart';

String lastSOSWalkerId = "";
int lastSOSTime;

class NotificationManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _NotificationManagerPageState();
  }
}

class _NotificationManagerPageState extends State<NotificationManagerPage> {
  bool _isLoading = true;
  List<Widget> walkerCards = [];

  @override
  void initState() {
    super.initState();
    if(lastSOSWalkerId.isEmpty) {
      _isLoading = false;
      return;
    }
    _loadData(context).then((data) {
      print("Load data done");
      if(data == null) {
        setState(() {
          _isLoading = false;
        });
      }
      else {
      setState(() {
        data.forEach((k, v) {
          if (v['ccid'] == lastSOSWalkerId)
            walkerCards.add(_buildSOSCard(k, v, context));
        });
        print("Added card");
        _isLoading = false;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Center")),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          lastSOSWalkerId = "";
          Navigator.pop(context);
        },
        tooltip: 'Clear messages',
        child: Icon(Icons.clear),
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
      return Center(child: Text("No new messages. Your patients are doing good."));
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

Future<Map> _loadData(BuildContext context) async {
  DB db = await getDB(context);
  var walkerData = await db.getWalkersData();
  return walkerData;
}

Widget _buildSOSCard(String ccid, Map dataMap, BuildContext context) {
  String walkerName = dataMap['name'];
  var latestData = dataMap;
  int updatedTime = int.parse(latestData['time']);
//  double latestLat = latestData['lat'];
//  double latestLon = latestData['lon'];
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.warning),
            title: Text('$walkerName -- SOS'),
            subtitle: Text(dataMap['addr'] + '\n' + "Location updated ${readTimestamp(updatedTime)}"),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('View activity'),
                  onPressed: () {
                    print("Setting $walkerName as current patient");
                    setPatient(walkerName, latestData);
                    Navigator.of(context).pushNamed('/map');
                  },
                ),
//                IconButton(icon: Icon(Icons.settings), onPressed: () {},),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}