import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutterdelivery/services/authentication.dart';
import 'package:geolocator/geolocator.dart';
import '../../Charts/presentation/ChartPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Initialization of Variables
  final TextEditingController _addressTextController = TextEditingController();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager=true;
  List<String> _placemarkCoords = [];
  final Geolocator _geolocator = Geolocator();
  Placemark pos;
  Position _currentPosition;
  String _currentAddress;
  double _distance;

  /// Function for init state initialization
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Function for SignOut
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  /// Function for Widget Building
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(' HOME '),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Log Out',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_currentAddress != null) Text("Your Current Address is: $_currentAddress",style: TextStyle(fontSize: 15.0,color: Colors.red,fontWeight: FontWeight.bold),),
                  Padding(padding: EdgeInsets.all(20.0),),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Please enter an address', icon: Icon(Icons.home,color: Colors.grey,)
                    ),
                    controller: _addressTextController,
                  ),
                  Padding(padding: EdgeInsets.all(20.0),),
                  if (_distance != null) Text("The distance between your current location and Address entered is $_distance metres"),
                  Padding(padding: EdgeInsets.all(20.0),),
                  if (_distance != null&&_distance<=100 && _distance>40) Text("You will reach destination in 100 minutes"),
                  if (_distance != null&&_distance>100 ) Text("You will reach destination in more than 100 minutes"),
                  if (_distance != null&&_distance<40) Text("You will reach destination in 40 minutes"),
                  Padding(padding: EdgeInsets.all(20.0)),
                  RaisedButton(
                    child: const Text('Find Distance'),
                    onPressed: () {
                      _onLookupCoordinatesPressed(context);
                    },
                  ),
                  RaisedButton(
                    child: const Text('Display Charts'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChartPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  /// For getting coordinates from entered Address
  Future<void> _onLookupCoordinatesPressed(BuildContext context) async {
    final List<Placemark> placemarks = await Future(
            () => _geolocator.placemarkFromAddress(_addressTextController.text))
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(onError.toString()),
      ));
      return Future.value(List<Placemark>());
    });
    if (placemarks != null && placemarks.isNotEmpty) {
      pos = placemarks[0];
      _onCalculatePressed();
      final List<String> coords = placemarks
          .map((placemark) =>
      pos.position?.latitude.toString() +
          ', ' +
          pos.position?.longitude.toString())
          .toList();
      setState(() {
        _placemarkCoords = coords;
      });
    }
  }

  /// For Calculating the distance between entered address and current location in metres
  Future<void> _onCalculatePressed() async {
    final double startLatitude = double.parse(pos.position?.latitude.toString());
    final double startLongitude = double.parse(pos.position?.longitude.toString());
    final double endLatitude = double.parse(_currentPosition.latitude.toString());
    final double endLongitude = double.parse(_currentPosition.longitude.toString());
    final double distance = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    setState(() {
      _distance = distance;
    });
  }

  /// Function for getting Current Location
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  /// Function for getting Address from coordinates
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
        "${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

/// Function for back pressed Event
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    ) ?? false;
  }

}
