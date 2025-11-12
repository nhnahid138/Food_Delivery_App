import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/payment.dart';
import 'package:food/pages/widget_helper.dart';
int?totalpayment;

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  User? user = FirebaseAuth.instance.currentUser;
  var totalpay = 0;

  @override
  Widget build(BuildContext context) {

    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Page"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, asyncSnapshot) {

          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var datu =
              asyncSnapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};
          List carts = datu['cart'] ?? [];

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('admin').doc('product').snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var data = snapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};
              List items = data['item'] ?? [];


              int subtotal = 0;
              for (var c in carts) {
                try {
                  final int itemIndex = c['itemIndex'] is int ? c['itemIndex'] : int.parse(c['itemIndex'].toString());
                  final int quantity = c['quantity'] is int ? c['quantity'] : int.parse(c['quantity'].toString());
                  if (itemIndex >= 0 && itemIndex < items.length) {
                    final item = items[itemIndex];
                    final int price = int.tryParse(item['price'].toString()) ?? 0;
                    subtotal += price * quantity;
                  }
                } catch (_) {

                }
              }
              totalpay = subtotal;
              totalpayment = subtotal + 60;

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 160),
                    child: ListView.builder(
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        var cart = carts[index];
                        var item = (cart['itemIndex'] is int && cart['itemIndex'] < items.length)
                            ? items[cart['itemIndex']]
                            : null;
                        if (item == null) {
                          return SizedBox.shrink();
                        }
                        final int quantity = cart['quantity'] is int ? cart['quantity'] : int.parse(cart['quantity'].toString());
                        final int itemPrice = int.tryParse(item['price'].toString()) ?? 0;
                        final int totalPrice = itemPrice * quantity;

                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      item['image'],
                                      height: appHeight * 0.15,
                                      width: appWidth * 0.34,
                                      errorBuilder: (_, __, ___) => SizedBox(
                                        height: appHeight * 0.15,
                                        width: appWidth * 0.34,
                                        child: Center(child: Icon(Icons.broken_image)),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${item['title']}", style: appWidget.boldText(25)),
                                        Text("${item['subtitle']}", style: appWidget.subText(15)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("TK $totalPrice", style: appWidget.boldText(20)),
                                            Padding(
                                              padding: EdgeInsets.only(right: appWidth * 0.03),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.plus_circle_fill),
                                                  SizedBox(width: appWidth * 0.03),
                                                  Text('$quantity', style: appWidget.boldText(20)),
                                                  SizedBox(width: appWidth * 0.03),
                                                  Icon(CupertinoIcons.minus_circle_fill),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('SubTotal: ', style: appWidget.colorboldText(20, Colors.black)),
                                  Text('(Including Tax) ', style: appWidget.subText(15)),
                                ],
                              ),
                              Text('TK $subtotal', style: appWidget.colorboldText(20, Colors.black))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Charge: ', style: appWidget.boldText(15)),
                              Text('TK      ${subtotal == 0 ? 0 : 60}', style: appWidget.colorboldText(15, Colors.black))
                            ],
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            width: appWidth,
                            child: Container(
                              height: 3,
                              width: 80,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Price: ', style: appWidget.colorboldText(22, Colors.deepPurple)),
                              Text('TK ${subtotal + (subtotal == 0 ? 0 : 60)}', style: appWidget.colorboldText(20, Colors.deepPurple))
                            ],
                          ),
                          Container(
                            width: appWidth,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>payment(totalpay: totalpay,)));
                              },
                              child: Text("Proceed to Pay", style: appWidget.colorboldText(20, Colors.white)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
