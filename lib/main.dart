import 'package:crud_e_ship/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), 
          ),
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.blue,
        ),
      ),
      home: const StartScreen(),
    );
  }
}