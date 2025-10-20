import 'package:flutter/material.dart';
import 'package:food/pages/bottom_nevigation.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/onBoard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: onBoard(),
    );
  }
}