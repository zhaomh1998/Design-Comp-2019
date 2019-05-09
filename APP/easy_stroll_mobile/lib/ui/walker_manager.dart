import 'package:flutter/material.dart';

class WalkerManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WalkerManagerPageState();
  }
}

class _WalkerManagerPageState extends State<WalkerManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("WalkerManagerPage Title")),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {print("Add walker");},
        tooltip: 'Add walker',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(context) {
    return Text("Walker Info Cards\nChoose which walker to display\nadd delete and stuff");
  }
}