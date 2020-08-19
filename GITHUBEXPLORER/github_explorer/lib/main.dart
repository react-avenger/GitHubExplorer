import 'package:flutter/material.dart';
import 'package:github_explorer/views/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repository Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Lato'),
      home: Dashboard(),
    );
  }
}
