import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/pages/cart.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/widget_helper.dart';

class order extends StatefulWidget {
  const order({super.key});

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  List? orders=[];
  List?order=[];
  User? user = FirebaseAuth.instance.currentUser;
  Map? orderData={};
  List items=[];
  int? total;
  String? orderId;
  int? orderDetails;

  @override
  void initState() {
    super.initState();
    setState(() {
      getOrderDetails();
      productDetails();

    });
  }

  Future<void> productDetails()async{
    DocumentSnapshot poc= await FirebaseFirestore.
    instance.collection('admin').doc('product').get();
    setState(() {
      var data = poc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
      items = data['item'] ?? [];

    });

  }

  Future<void> getOrderDetails() async {
    try{
   DocumentSnapshot doc = await FirebaseFirestore.
   instance.collection('users').doc(user!.uid).get();


    setState(() {
      orderData = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
      orders = orderData!['order']??[];



    });




    }catch(e){
      print("Error fetching order details: $e");
    }


  }

  Color statusColor(String status) {
    if (status == 'processing') {
      return Colors.orange;
    } else if (status == 'Shipped') {
      return Colors.green;
    } else if (status == 'Out for Delivery') {
      return Colors.blue;
    } else if (status == 'Delivered') {
      return Colors.green;
    } else if( status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body:ListView.builder(
        itemCount: orders!.length,
        itemBuilder: (context,index) {
          final ind = orders!.length - 1 - index;
          orderId=orders![ind]['orderId'];
          order = orders![ind]['items']??[];
          total=orders![ind]['total'];


          return Padding(
            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10,top:5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Id: $orderId',style: appWidget.boldText(20),),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                                  color: statusColor(orders![ind]['status']),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:5,bottom:8,left:15,right:10),
                                  child: Text(orders![ind]['status'],style: appWidget.colorboldText(15, Colors.white),),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: order!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                         itemBuilder: (context,index) {
                            var orderItems = order![index];
                            var orderItemIndex = orderItems['itemIndex'];
                            var quantity = orderItems['quantity'];
                            var item= items[orderItemIndex];
                            var price= int.parse(item['price'])*quantity;




                            return Padding(
                              padding: const EdgeInsets.only(left: 10,bottom: 10,right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Row(
                                    children: [
                                      Image.network(item['image'],height: 50,width: 50,),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            //color: Colors.red,
                                            width: 220,
                                            child: Text(item['title'],style: appWidget.boldText(20),),
                                          ),
                                          Text('Qty: $quantity',style: appWidget.boldText(16),),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Flexible(child: Text('$price TK',style: appWidget.boldText(17),)),

                                ],
                              ),
                            );
                          }
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:10,top:5),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(



                                    onTap: () {
                                      setState(() {
                                        orderDetails=ind;
                                      });
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true, // lets us control height
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        ),
                                        builder: (context) {
                                          return SizedBox(
                                            height: 300, // half screen
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(20),
                                                    ),
                                                    color: Colors.indigo[900],
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 10.0),
                                                          child: Text('Order Details ${orders![ind]['orderId']}',style: appWidget.colorboldText(20, Colors.white)),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(Icons.close,color: Colors.white),
                                                          onPressed: () {
                                                            Navigator.pop(context); // closes the bottom sheet
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Name : ${orders![ind]['name']}',style:TextStyle(fontSize: 20),),
                                                      Text('Phone : ${orders![ind]['phone']}',style:TextStyle(fontSize: 20),),
                                                      Text('Address : ${orders![ind]['address']}',style:TextStyle(fontSize: 20),),
                                                      Row(
                                                        children: [
                                                          Text('Status : ',style:TextStyle(fontSize: 20,)
                                                          ),
                                                          Text(orders![ind]['status'],style:TextStyle(fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: statusColor(orders![ind]['status'])
                                                          ),),
                                                        ],
                                                      ),
                                                      Text('Order Time : ${orders![ind]['date'].toDate().toString()}',style:TextStyle(fontSize: 20),),
                                                      Text(
                                                        'Shipped Time : ${orders?[ind]['shippedTime'] != null
                                                            ? (orders![ind]['shippedTime'] as Timestamp).toDate().toString()
                                                            : 'Not shipped yet'}',
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          // Cancel order logic
                                                          setState(() {
                                                            final adminOrderRef = FirebaseFirestore.instance
                                                                .collection('admin')
                                                                .doc('order')
                                                                .collection('userOrder');

// Replace 'orderu' with the order ID you want to update
                                                            adminOrderRef.doc(orders![ind]['orderId']).update({
                                                              'status': 'Cancelled', // new status
                                                            });

                                                            orders![ind]['status'] = 'Cancelled';
                                                          });
                                                          // Update in Firestore
                                                          await FirebaseFirestore.instance
                                                              .collection('users')
                                                              .doc(user!.uid)
                                                              .update({'order': orders});
                                                          Navigator.pop(context); // Close bottom sheet
                                                        },
                                                        child: Material(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.red,
                                                          elevation: 5,
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            width: MediaQuery.of(context).size.width,

                                                            height: 40,
                                                            child: Text('Cancel Order',style: appWidget.colorboldText(20, Colors.white)),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.indigo[900] ,
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topRight:Radius.circular(20) ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Text(' Order Details ' ,style: appWidget.colorboldText(16, Colors.white)),
                                            Icon(CupertinoIcons.info,color: Colors.white,size: 18,)
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),
                                 // ElevatedButton(onPressed: (){},
                                     // child:Text('Order Details') ),
                                  //Icon(CupertinoIcons.info_circle_fill),
                                  Text('Total Price: $total TK',style: appWidget.boldText(20),),
                                ],
                              )),
                        )
                      ],
                    ),



              ),
            ),
          );
        }
      ),
    );
  }
}
