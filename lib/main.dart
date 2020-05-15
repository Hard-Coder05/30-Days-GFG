import 'package:flutter/material.dart';
import 'package:flutterdelivery/pages/root_page.dart';
import 'package:flutterdelivery/services/authentication.dart';
void main() {
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Delivery App',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}