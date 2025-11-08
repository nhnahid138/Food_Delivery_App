import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/signUp.dart';
import 'package:food/pages/theme.dart';
import 'package:food/pages/user_order.dart';

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
  late userOrder orderPage;
  late signUp signUpPage;
  bool isHome=false;
  bool isWallet=false;
  bool isProfile=false;
  bool isOrder=false;
  @override
  void initState(){
    super.initState();
    homePage=home();
    walletPage=wallet();
    profilePage=profile();
    signUpPage=signUp();
    orderPage=userOrder();
    pages=[homePage,orderPage,walletPage, profilePage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.indigo[900]!,
        height: 60,
        animationDuration: Duration(milliseconds: 500),
        items: <Widget>[
          Icon(CupertinoIcons.home,color:Colors.white,),
          Icon(Icons.shopping_bag_outlined,color: Colors.white,),
          Icon(Icons.wallet,color: Colors.white,),
          Icon(CupertinoIcons.person,color:Colors.white,),
        ],
        onTap: (index) {
          setState(() {
            currentIndex=index;
            if(index==0){
              isHome=true;
              isWallet=false;
              isProfile=false;
              isOrder=false;
            }else if(index==1){
              isHome=false;
              isWallet=false;
              isProfile=false;
              isOrder=true;
            }else if(index==2){
              isHome=false;
              isWallet=true;
              isProfile=false;
              isOrder=false;}
            else if(index==3){
              isHome=false;
              isWallet=false;
              isProfile=true;
              isOrder=false;
            }
          });
          //Handle button tap
        },
      ),
      body: pages[currentIndex],
    );
  }
}
