import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutterdelivery/services/authentication.dart';
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
  Future navigateToNewPage(context) async {
    /// Navigator.push(context, MaterialPageRoute(builder: (context) =>NewPage() ));
  }
  Future navigateToImageAPI(context) async {
    /// Navigator.push(context, MaterialPageRoute(builder: (context) => DataPage()));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
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
                  Padding(padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),),
                  Center(
                    child: FlatButton(child: Text("Image API Service",style: TextStyle(color: Colors.white,fontSize: 20.0),),
                      onPressed: () {navigateToImageAPI(context);},
                      color: Colors.lightBlue,
                      colorBrightness: Brightness.dark,
                      disabledColor:Colors.blueGrey,
                      highlightColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),),
                  FlatButton(
                    child: Text("Check Internet Connectivity",style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    onPressed: () {navigateToNewPage(context);},
                    color: Colors.lightBlue,
                    colorBrightness: Brightness.dark,
                    disabledColor:Colors.blueGrey,
                    highlightColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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