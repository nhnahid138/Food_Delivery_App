import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class appWidget{
  static TextStyle boldText(double size){
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }
  static TextStyle subText(double size){
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: Colors.black38,
    );
  }


  static TextStyle colorboldText(double size, Color color){
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }



}