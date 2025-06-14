
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(VeriPosteApp());

class VeriPosteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VeriPoste',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}
