import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class wallet extends StatefulWidget {
  const wallet({super.key});

  @override
  State<wallet> createState() => _walletState();
}

class _walletState extends State<wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Wallet page",style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
