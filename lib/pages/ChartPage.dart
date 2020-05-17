import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:numberpicker/numberpicker.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => new _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List data;
  Timer timer;
  int _current=2000;

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (context) {
          return new NumberPickerDialog.integer(
            minValue: 1910,
            maxValue: 2017,
            title: new Text("Pick a new price"),
            initialIntegerValue: _current,
          );
        }
    ).then((value) => _current = value);
  }

  makeRequest() async {
    var response = await http.get(
      'https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice/Rainfall-England.json',
      headers: {'Accept': 'application/json'},
    );

    setState(() {
      data = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(new Duration(seconds: 2), (t) => makeRequest());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Year $_current RainFall in England'),
      ),
      body: data == null ? CircularProgressIndicator() : createChart(),
      floatingActionButton: new FloatingActionButton.extended(
        icon: Icon(Icons.attach_money),
        tooltip: "Select Year",
        label: Text("Select Year"),
        onPressed: _showDialog,
      ),
    );
  }

  charts.Series<LiveWerkzeuge, String> createSeries(int i) {
    return charts.Series<LiveWerkzeuge, String>(
      id: "DATA",
      domainFn: (LiveWerkzeuge wear, _) => wear.wsp,
      measureFn: (LiveWerkzeuge wear, _) => wear.belastung,
      displayName: "Year = $_current",
      data: [
        LiveWerkzeuge('JAN', data[i+0]['value']),
        LiveWerkzeuge('FEB', data[i+1]['value']),
        LiveWerkzeuge('MAR', data[i+2]['value']),
        LiveWerkzeuge('APR', data[i+3]['value']),
        LiveWerkzeuge('MAY', data[i+4]['value']),
        LiveWerkzeuge('JUN', data[i+5]['value']),
        LiveWerkzeuge('JUL', data[i+6]['value']),
        LiveWerkzeuge('AUG', data[i+7]['value']),
        LiveWerkzeuge('SEP', data[i+8]['value']),
        LiveWerkzeuge('OCT', data[i+9]['value']),
        LiveWerkzeuge('NOV', data[i+10]['value']),
        LiveWerkzeuge('DEC', data[i+11]['value']),
      ],
    );
  }

  Widget createChart() {
    List<charts.Series<LiveWerkzeuge, String>> seriesList = [];
    int i=0+(_current-1910)*12;
    seriesList.add(createSeries(i));
    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class LiveWerkzeuge {
  final String wsp;
  final double belastung;
  LiveWerkzeuge(this.wsp, this.belastung);
}