import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutterdelivery/services/authentication.dart';
import 'package:geolocator/geolocator.dart';

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
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager=true;

  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    super.initState();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

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
                  if (_currentAddress != null) Text(_currentAddress),
                  FlatButton(
                    child: Text("Find Current Location",style: TextStyle(color: Colors.white)),
                    color: Colors.green,
                    onPressed: () {
                      _getCurrentLocation();
                    },
                  ),
                  TextField(
                    decoration:
                    const InputDecoration(hintText: 'Please enter an address'),
                    controller: _addressTextController,
                  ),
                  if (_distance != null) Text(_distance),
                  RaisedButton(
                    child: const Text('Find Distance'),
                    onPressed: () {
                      _onLookupCoordinatesPressed(context);
                      _onCalculatePressed();
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

  final Geolocator _geolocator = Geolocator();
  final TextEditingController _addressTextController = TextEditingController();

  List<String> _placemarkCoords = [];
  Placemark pos;
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
String _distance;
  Future<void> _onCalculatePressed() async {

    final double startLatitude = double.parse(pos.position?.latitude.toString());
    final double startLongitude = double.parse(pos.position?.longitude.toString());
    final double endLatitude = double.parse(_currentPosition.latitude.toString());
    final double endLongitude = double.parse(_currentPosition.longitude.toString());

    final double distance = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    setState(() {
      _distance = distance.toString();
    });
  }

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
