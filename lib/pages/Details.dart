import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(Icons.arrow_back_ios,color: Colors.black,),
              ),
            ),
            Image.asset("img/salad4.png",
              height: MediaQuery.of(context).size.height/2.5,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,),
          ],
        )
      ),
    );
  }
}
