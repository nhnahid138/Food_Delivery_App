import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/adminApp/adminOrder.dart';
import 'package:food/adminApp/adminProfile.dart';
import 'package:food/adminApp/dashboard.dart';
import 'package:food/pages/admin.dart';

class adminBottomNev extends StatefulWidget {
  const adminBottomNev({super.key});

  @override
  State<adminBottomNev> createState() => _adminBottomNevState();
}

class _adminBottomNevState extends State<adminBottomNev> {
  List<Widget> adminPages=[];

  late dashboard _dash;
  late adminorder _order;
  late admin _addProduct;
  late adminProfile _adminProfile;
  int currentIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dash=dashboard();
    _order=adminorder();
    _addProduct=admin();
    _adminProfile=adminProfile();

  adminPages=[_dash,_order,_addProduct,_adminProfile];
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.pink[900]!,
        height: 60,
        animationDuration: Duration(milliseconds: 500),
        onTap: (index){
          setState(() {
            currentIndex=index;
          });
        },
          items: <Widget>[
            Icon(Icons.space_dashboard_rounded,color: Colors.white,),
            Icon(Icons.shopping_bag_outlined,color:Colors.white,),
            Icon(Icons.add_box_outlined,color: Colors.white,),
            Icon(CupertinoIcons.person,color:Colors.white,),
          ],
      ),
      body: adminPages[currentIndex],
    );
  }
}
