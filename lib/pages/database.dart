import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/pages/cart.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/widget_helper.dart';
class database{
  User? user = FirebaseAuth.instance.currentUser;
  Future<Map<String, dynamic>> userData()async{
   DocumentSnapshot doc=  await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    var data = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
    List item= data['cart'];
    return data;
  }
}
