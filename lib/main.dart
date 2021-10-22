
import 'package:flutter/material.dart';
import 'island.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Island',
      theme: ThemeData(primaryColor: Colors.blue, accentColor: Colors.blueAccent),
      home: IslandPage(title: ' Island'),
    );
  }
}