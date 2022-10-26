import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "計算脳トレ", theme: ThemeData.dark(), home: HomeScreen());
  }
}
