import 'dart:io';

import 'package:easy_stroll_mobile/util/var.dart';
import 'package:flutter/material.dart';
import '../util/current_patient.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';


class AnalysisPage extends StatefulWidget {
  AnalysisPage({Key key}) : super(key: key);

  @override
  _AnalysisPageStates createState() => new _AnalysisPageStates();
}

class _AnalysisPageStates extends State<AnalysisPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$patientName's Activity Analysis")),
      body: new HorizontalBarChart(HorizontalBarChart._createSampleData()),
//      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: Text("Body"),),
        Expanded(child: Text("Secondary"))
      ],
    );
  }

}

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory HorizontalBarChart.withSampleData() {
    return new HorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('0', 5),
      new OrdinalSales('1', 25),
      new OrdinalSales('2', 100),
      new OrdinalSales('3', 75),
      new OrdinalSales('4', 5),
      new OrdinalSales('5', 25),
      new OrdinalSales('6', 100),
      new OrdinalSales('7', 75),
      new OrdinalSales('8', 5),
      new OrdinalSales('9', 25),
      new OrdinalSales('10', 100),
      new OrdinalSales('11', 75),
      new OrdinalSales('12', 5),
      new OrdinalSales('13', 25),
      new OrdinalSales('14', 100),
      new OrdinalSales('15', 75),
      new OrdinalSales('16', 5),
      new OrdinalSales('17', 25),
      new OrdinalSales('18', 100),
      new OrdinalSales('19', 75),
      new OrdinalSales('20', 5),
      new OrdinalSales('21', 25),
      new OrdinalSales('22', 100),
      new OrdinalSales('23', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}