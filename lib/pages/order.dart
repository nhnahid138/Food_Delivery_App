import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Order Page",style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
