import 'package:flutter/material.dart';
import 'package:food/pages/bottom_nevigation.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/onBoard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food/pages/widget_helper.dart';
double? appHeight;
double? appWidth;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    appHeight=height;
    appWidth=width;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: onBoard(),

    );
  }
}