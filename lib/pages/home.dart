import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/widget_helper.dart';

import 'Details.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool icecream=false;
  bool pizza=false;
  bool salad=false;
  bool burger=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50,left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hello NAHID,",style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                      ,),
                    GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));},
                      child: Container(
                        decoration: BoxDecoration(
                          color:Colors.black,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(CupertinoIcons.cart_fill,color: Colors.white,),
                        )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Text("Delicious Food",style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )
                ,),
              Text("Discover and Get Great Food",style: TextStyle(
                color: Colors.black38,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
                ,),
        
              SizedBox(height: 20),
              
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          icecream=true;
                          pizza=false;
                          salad=false;
                          burger=false;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:icecream?Colors.black:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("img/ice-cream.png",
                              height: 40,width: 40,fit: BoxFit.cover,
                            color:icecream?Colors.white:Colors.black ,),
                          ),
                        ),
                      ),
                    ),
        
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          icecream=false;
                          pizza=true;
                          salad=false;
                          burger=false;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:pizza?Colors.black:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("img/pizza.png",
                              height: 40,width: 40,fit: BoxFit.cover,
                              color:pizza?Colors.white:Colors.black ,),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          icecream=false;
                          pizza=false;
                          salad=true;
                          burger=false;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:salad?Colors.black:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("img/salad.png",
                              height: 40,width: 40,fit: BoxFit.cover,
                              color:salad?Colors.white:Colors.black ,),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          icecream=false;
                          pizza=false;
                          salad=false;
                          burger=true;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:burger?Colors.black:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("img/burger.png",
                              height: 40,width: 40,fit: BoxFit.cover,
                              color:burger?Colors.white:Colors.black ,),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              
              SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 4),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("img/salad2.png",height: 150,
                                  width: 150,fit: BoxFit.cover,),
                                  Text("Vegan Salad Bowl",style:appWidget.boldText(20),),
                                  Text("Fresh and Healthy",style: appWidget.subText(15),),
                                  Text("\$12.00",style: appWidget.boldText(20),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Container(
                        margin: EdgeInsets.only(right: 4),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("img/salad4.png",height: 150,
                                    width: 150,fit: BoxFit.cover,),
                                  Text("Vegan Salad Bowl",style:appWidget.boldText(20),),
                                  Text("Fresh and Healthy",style: appWidget.subText(15),),
                                  Text("\$12.00",style: appWidget.boldText(20),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
        
                      Container(
                        margin: EdgeInsets.only(right: 4),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("img/salad3.png",height: 150,
                                    width: 150,fit: BoxFit.cover,),
                                  Text("Vegan Salad Bowl",style:appWidget.boldText(20),),
                                  Text("Fresh and Healthy",style: appWidget.subText(15),),
                                  Text("\$12.00",style: appWidget.boldText(20),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20,bottom: 10),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: Row(
                        children: [
                          Image.asset("img/salad4.png",height: 170,width: 170,),
                          SizedBox(width: 20,),
                          Container(
                            height: 150,
                              width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Vegetable With Cisy Salad",style: appWidget.boldText(20),),
                                  Text("Fresh and Healthy",style: appWidget.subText(15),),
                                  Text("\$15.00",style: appWidget.boldText(20),),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20,bottom: 10),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: Row(
                        children: [
                          Image.asset("img/salad2.png",height: 170,width: 170,),
                          SizedBox(width: 20,),
                          Container(
                              height: 150,
                              width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Vegetable With Cisy Salad",style: appWidget.boldText(20),),
                                  Text("Fresh and Healthy",style: appWidget.subText(15),),
                                  Text("\$15.00",style: appWidget.boldText(20),),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
