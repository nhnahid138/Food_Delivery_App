import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/pages/bottom_nevigation.dart';
import 'package:food/pages/cart.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/widget_helper.dart';

class userOrder extends StatefulWidget {
  const userOrder({super.key});

  @override
  State<userOrder> createState() => _orderState();
}

class _orderState extends State<userOrder> {
  List? orders=[];
  List?order=[];
  User? user = FirebaseAuth.instance.currentUser;
  Map? orderData={};
  List items=[];
  int? total;
  String? orderDetails;

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }




  Color statusColor(String status) {
    if (status == 'processing') {
      return Colors.orange;
    } else if (status == 'Shipped') {
      return Colors.green;
    } else if (status == 'Out for Delivery') {
      return Colors.blue;
    } else if (status == 'Delivered') {
      return Colors.blue;
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => bottomNev()));
          },
        ),

      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid)
          .collection('orders').snapshots(),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final snapOrders = asyncSnapshot.data!.docs;
          return ListView.builder(
              itemCount: snapOrders.length,
              itemBuilder: (context,index) {
                index=snapOrders.length - 1 - index;
                var snapOrder = snapOrders[index];
                List orderItems=snapOrder['items'];
                var totalp =snapOrder['total'];
                String orderId=snapOrder['orderId'];



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
                                Text('Order Id: ${snapOrder['orderId']}',style: appWidget.boldText(20),),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                                    color: statusColor(snapOrder['status']),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5,bottom:8,left:15,right:10),
                                    child: Text(snapOrder['status'],style: appWidget.colorboldText(15, Colors.white),),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ListView.builder(
                              itemCount: orderItems.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),

                              itemBuilder: (context,index) {
                                var orderItem=orderItems[index];
                                String productId=orderItem['productId'];
                                int quantity=orderItem['quantity'];




                                return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('admin')
                                      .doc('product')
                                      .collection('productCollection')
                                  .doc(productId)
                                      .snapshots(),
                                  builder: (context, asyncSnapshot) {
                                    if (!asyncSnapshot.hasData) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    var productData = asyncSnapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};
                                    int price = int.tryParse(productData['price'].toString()) ?? 0;
                                    var totalPrice = price * quantity;
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10,bottom: 10,right: 10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          Row(
                                            children: [
                                              Image.network(productData['image'],height: 50,width: 50,),
                                              SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    //color: Colors.red,
                                                    width: 220,
                                                    child: Text(productData['title'],style: appWidget.boldText(20),),
                                                  ),
                                                  Text('Qty: $quantity',style: appWidget.boldText(16),),
                                                ],
                                              ),
                                            ],
                                          ),

                                          Flexible(child: Text('$totalPrice TK',style: appWidget.boldText(17),)),

                                        ],
                                      ),
                                    );
                                  }
                                );
                              }
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('orders')
                                .doc(orderId)
                                .snapshots(),
                            builder: (context, asyncSnapshot) {
                              if (!asyncSnapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                              }
                              var pdata = asyncSnapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};



                              return Padding(
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
                                              orderDetails=orderId;
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
                                                  height: 340, // half screen
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
                                                                child: Text('Order Details $orderId ',style: appWidget.colorboldText(20, Colors.white)),
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
                                                            Text('Name : ${pdata['name']}',style:TextStyle(fontSize: 20),),
                                                            Text('Phone : ${pdata['phone']}',style:TextStyle(fontSize: 20),),
                                                            Text('Address : ${pdata['address']}',style:TextStyle(fontSize: 20),),
                                                            Row(
                                                              children: [
                                                                Text('Status : ',style:TextStyle(fontSize: 20,)
                                                                ),
                                                                Text(pdata['status'],style:TextStyle(fontSize: 20,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: statusColor(pdata['status'])
                                                                ),),
                                                              ],
                                                            ),
                                                            Text('Order Time : ${pdata['date'].toDate().toString()}',style:TextStyle(fontSize: 20),),
                                                            Text(
                                                              'Shipped Time : ${pdata['shippedTime'] != null
                                                                  ? (pdata['shippedTime'] as Timestamp).toDate().toString()
                                                                  : 'Not shipped yet'}',
                                                              style: TextStyle(fontSize: 20),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('Payment Type :  ',style:TextStyle(fontSize: 20),),
                                                                Image.asset(pdata['paymentMethod'],height: 30,width: 30,)
                                                              ],
                                                            ),
                                                            SizedBox(height: 10,),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                // Cancel order logic
                                                                setState(() async {
                                                                  final adminOrderRef = await FirebaseFirestore.instance
                                                                      .collection('admin')
                                                                      .doc('order')
                                                                      .collection('userOrder');

                                                                  adminOrderRef.doc(pdata['orderId']).update({
                                                                    'status': 'Cancelled', // new status
                                                                  });

                                                                  pdata['status'] = 'Cancelled';
                                                                  final userRef = await FirebaseFirestore.instance
                                                                      .collection('users')
                                                                      .doc(user!.uid)
                                                                      .collection('orders');
                                                                  userRef.doc(pdata['orderId']).update({
                                                                    'status': 'Cancelled', // new status
                                                                  });
                                                                   Navigator.pop(context);
                                                                });














                                                                // Update in Firestore
                                                                // await FirebaseFirestore.instance
                                                                //     .collection('users')
                                                                //     .doc(user!.uid)
                                                                //     .update({'order': orders});// Close bottom sheet
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
                                        Text('Total Price: $totalp TK',style: appWidget.boldText(20),),
                                      ],
                                    )),
                              );
                            }
                          )








                        ],
                      ),



                    ),
                  ),
                );
              }
          );
        }
      ),
    );
  }
}
