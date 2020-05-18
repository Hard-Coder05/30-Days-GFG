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

  /// Function to show Dialog Box for Selecting Year
  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (context) {
          return new NumberPickerDialog.integer(
            minValue: 1910,
            maxValue: 2017,
            title: new Text("Pick a Year"),
            initialIntegerValue: _current,
          );
        }
    ).then((value) => _current = value);
  }

  /// Function to call API Data
  makeRequest() async {
    var response = await http.get(
      'https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice/Rainfall-England.json',
      headers: {'Accept': 'application/json'},
    );
    setState(() {
      data = json.decode(response.body);
    });
  }

  /// Function for init state
  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(new Duration(seconds: 1), (t) => makeRequest());
  }

  /// Function for Disposal of Timer
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Main widget
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('RainFall in England in Year $_current '),
      ),
      body: data == null ? WaitingScreen() : createChart(),
      floatingActionButton: new FloatingActionButton.extended(
        icon: Icon(Icons.date_range),
        tooltip: "Select Year",
        label: Text("Select Year"),
        onPressed: _showDialog,
      ),
    );
  }

  /// Function for creating Bar Chart Data Items
  charts.Series<WeatherData, String> createSeries(int i) {
    return charts.Series<WeatherData, String>(
      id: "DATA",
      domainFn: (WeatherData dd, _) => dd.Month,
      measureFn: (WeatherData dd, _) => dd.Value,
      data: [
        WeatherData('JAN', data[i+0]['value']),
        WeatherData('FEB', data[i+1]['value']),
        WeatherData('MAR', data[i+2]['value']),
        WeatherData('APR', data[i+3]['value']),
        WeatherData('MAY', data[i+4]['value']),
        WeatherData('JUN', data[i+5]['value']),
        WeatherData('JUL', data[i+6]['value']),
        WeatherData('AUG', data[i+7]['value']),
        WeatherData('SEP', data[i+8]['value']),
        WeatherData('OCT', data[i+9]['value']),
        WeatherData('NOV', data[i+10]['value']),
        WeatherData('DEC', data[i+11]['value']),
      ],
    );
  }

  /// Function for creating Bar Chart
  Widget createChart() {
    List<charts.Series<WeatherData, String>> seriesList = [];
    int i=0+(_current-1910)*12;
    seriesList.add(createSeries(i));
    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  Widget WaitingScreen(){
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.lightBlue),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 120.0,
                        child: CircleAvatar(
                          child: Text("COMPANY LOGO"),
                          radius: 100.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/// The Model for the JSON API Data
class WeatherData {
  final String Month;
  final double Value;
  WeatherData(this.Month, this.Value);
}


