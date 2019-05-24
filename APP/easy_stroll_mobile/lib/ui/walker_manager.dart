import 'package:easy_stroll_mobile/util/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/var.dart';


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
        data.forEach((k, v) {walkerCards.add(_buildCard(k, v));});
        print("Added card");
        _isLoading = false;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WalkerManagerPage Title")),
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

Widget _buildCard(String ccid, Map dataMap) {
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
            leading: Icon(Icons.shopping_cart),
            title: Text(walkerName),
            subtitle: Text(dataMap['addr'] + '\n' + "Last seen ${readTimestamp(updatedTime)}"),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('View activity'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                IconButton(icon: Icon(Icons.settings), onPressed: () {},),
              ],
            ),
          ),
        ],
      ),
    ),
  );
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