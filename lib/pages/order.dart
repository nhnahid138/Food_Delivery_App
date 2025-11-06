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
  int? orderid=1123;

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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body:ListView.builder(
        itemCount: orders!.length,
        itemBuilder: (context,ind) {
          order = orders![ind]['items']??[];
          total=orders![ind]['total'];
          orderid=orderid!+ind;


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
                              Text('Order Id: #QFD$orderid',style: appWidget.boldText(20),),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                                  color: Colors.deepPurple,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                                  child: Text('Processing',style: appWidget.colorboldText(15, Colors.white),),
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
                                          Flexible(
                                              child: Text(item['title'],style: appWidget.boldText(20),)
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple ,
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
