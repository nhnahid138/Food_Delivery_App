import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'order.dart';
import 'profile.dart';
import 'wallet.dart';

class bottomNev extends StatefulWidget {
  const bottomNev({super.key});

  @override
  State<bottomNev> createState() => _bottomNevState();
}

class _bottomNevState extends State<bottomNev> {
  late List<Widget> pages;
  late home homePage;
  int currentIndex=0;
  late wallet walletPage;
  late profile profilePage;
  late order orderPage;
  @override
  void initState(){
    super.initState();
    homePage=home();
    walletPage=wallet();
    profilePage=profile();
    orderPage=order();
    pages=[homePage,orderPage,walletPage,profilePage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.black,
        height: 60,
        animationDuration: Duration(milliseconds: 500),
        items: <Widget>[
          Icon(CupertinoIcons.home,color: Colors.white,),
          Icon(Icons.shopping_bag_outlined,color: Colors.white,),
          Icon(Icons.wallet,color: Colors.white,),
          Icon(CupertinoIcons.person,color: Colors.white,),
        ],
        onTap: (index) {
          setState(() {
            currentIndex=index;
          });
          //Handle button tap
        },
      ),
      body: pages[currentIndex],
    );
  }
}
