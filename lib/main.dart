import 'package:flutter/material.dart';
import 'package:pimpmynurse/screens/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pimp my nurse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        //primarySwatch: Colors.blueGrey,
      ),
      home: Home(),
    );
  }
}
