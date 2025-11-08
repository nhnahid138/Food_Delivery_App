import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/payment.dart';
import 'package:food/pages/widget_helper.dart';

class user_cart extends StatefulWidget {
  const user_cart({super.key});

  @override
  State<user_cart> createState() => _user_cartState();
}

class _user_cartState extends State<user_cart> {
  // helper to update quantity in Firestore by replacing the item at index
  Future<void> _updateQuantityInFirestore(int index, int newQuantity, List cartItems) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      // create a deep copy of cart items as list of maps
      List<Map<String, dynamic>> updatedCart = cartItems
          .map((e) => e is Map ? Map<String, dynamic>.from(e) : Map<String, dynamic>.from(e as Map))
          .toList();

      // guard index range
      if (index < 0 || index >= updatedCart.length) return;

      updatedCart[index]['quantity'] = newQuantity;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'cart': updatedCart});
    } catch (e) {
      // simple error logging; adapt as needed
      debugPrint('Error updating cart quantity: $e');
    }
  }

  // new: helper to delete an item from cart by index
  Future<void> _deleteItemFromCart(int index, List cartItems) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      List<Map<String, dynamic>> updatedCart = cartItems
          .map((e) => e is Map ? Map<String, dynamic>.from(e) : Map<String, dynamic>.from(e as Map))
          .toList();

      if (index < 0 || index >= updatedCart.length) return;

      updatedCart.removeAt(index);
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'cart': updatedCart});
    } catch (e) {
      debugPrint('Error deleting cart item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;
    const int deliveryCharge = 60;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var data = snapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};
              List cartItems = data['cart'] ?? [];

              // collect productIds
              List<String> productIds = cartItems.map<String>((e) => (e['productId'] ?? '').toString()).where((id) => id.isNotEmpty).toList();

              // if no products, show empty state
              if (productIds.isEmpty) {
                return Center(child: Text('Your cart is empty'));
              }

              // fetch all product docs once
              final futureProducts = Future.wait(productIds.map((id) =>
                  FirebaseFirestore.instance
                      .collection('admin')
                      .doc('product')
                      .collection('productCollection')
                      .doc(id)
                      .get()).toList());

              return FutureBuilder<List<DocumentSnapshot>>(
                future: futureProducts,
                builder: (context, prodSnapshot) {
                  if (!prodSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final productDocs = prodSnapshot.data!;
                  // compute subtotal as int
                  int subtotal = 0;
                  for (int i = 0; i < cartItems.length; i++) {
                    var item = cartItems[i];
                    String pid = (item['productId'] ?? '').toString();
                    int quantity = item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 0;
                    final prodDoc = productDocs.firstWhere((d) => d.id == pid,);
                    if (prodDoc != null && prodDoc.exists) {
                      var pData = prodDoc.data() as Map<String, dynamic>? ?? {};
                      // parse price as double then round to int
                      double priceDouble = double.tryParse(pData['price']?.toString() ?? '0') ?? 0.0;
                      int priceInt = priceDouble.round();
                      subtotal += priceInt * quantity;
                    }
                  }

                  final int total = subtotal + deliveryCharge;

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: appHeight * 0.30), // leave space for bottom summary
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      String productId = (item['productId'] ?? '').toString();
                      int quantity = item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 0;

                      // find matching product doc
                      final prodDoc = productDocs.firstWhere((d) => d.id == productId);
                      final productData = (prodDoc != null && prodDoc.exists) ? (prodDoc.data() as Map<String, dynamic>) : <String, dynamic>{};
                      final title = productData['title'] ?? productData['name'] ?? 'Unknown';
                      final subtitle = productData['subtitle'] ?? '';
                      final image = productData['image'] ?? '';
                      final price = (double.tryParse(productData['price']?.toString() ?? '0') ?? 0.0);
                      final int priceInt = price.round();

                      return Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        child: Stack(
                          children: [
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                // changed: wrap item content in Stack to show delete button at top-right
                                child: Stack(
                                  children: [
                                    // main row content
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            image,
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
                                              Text(title, style: appWidget.boldText(25)),
                                              Text(subtitle, style: appWidget.subText(15)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("TK $priceInt", style: appWidget.boldText(20)),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: appWidth * 0.03),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              int count = quantity;
                                                              if (count > 1) {
                                                                int newCount = count - 1;
                                                                // update Firestore (will trigger StreamBuilder rebuild)
                                                                _updateQuantityInFirestore(index, newCount, cartItems);
                                                              }
                                                            },
                                                            child: Icon(CupertinoIcons.minus_circle_fill)),
                                                        SizedBox(width: appWidth * 0.03),
                                                        Text('$quantity', style: appWidget.boldText(20)),
                                                        SizedBox(width: appWidth * 0.03),
                                                        GestureDetector(
                                                            onTap: () {
                                                              int newCount = quantity + 1;
                                                              _updateQuantityInFirestore(index, newCount, cartItems);
                                                            },
                                                            child: Icon(CupertinoIcons.plus_circle_fill)),
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
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentGeometry.topRight,
                              child: GestureDetector(
                                onTap: () async {
                                  // confirm deletion (optional)
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Remove item'),
                                      content: Text('Are you sure you want to remove this item from cart?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Remove')),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    _deleteItemFromCart(index, cartItems);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text('Remove',style: appWidget.colorboldText(16, Colors.white,),),
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),

          // bottom summary fixed area
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // We'll recompute amounts using a separate StreamBuilder to ensure bottom shows up-to-date values.
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      int subtotal = 0;
                      if (snapshot.hasData) {
                        var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                        List cartItems = data['cart'] ?? [];
                        // fetch product prices synchronously is not possible here, so show placeholder and compute again below
                      }

                      // Better: compute subtotal by refetching product docs synchronously here as well (simple approach):
                      // Note: For simplicity and to avoid nested async in the bottom area here, we'll display amounts using a FutureBuilder
                      return FutureBuilder<int>(
                        future: _computeSubtotalForCurrentUser(),
                        builder: (context, snap) {
                          int computedSubtotal = snap.data ?? 0;
                          final int delivery = deliveryCharge;
                          final int totalPrice = computedSubtotal + delivery;
                          return Column(
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
                                  Text('TK $computedSubtotal', style: appWidget.colorboldText(20, Colors.black))
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Charge: ', style: appWidget.boldText(15)),
                                  Text('TK $delivery', style: appWidget.colorboldText(15, Colors.black))
                                ],
                              ),
                              SizedBox(height: 6),
                              Container(
                                alignment: Alignment.topRight,
                                width: appWidth,
                                child: Container(
                                  height: 3,
                                  width: 80,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Price: ', style: appWidget.colorboldText(22, Colors.deepPurple)),
                                  Text('TK $totalPrice', style: appWidget.colorboldText(20, Colors.deepPurple))
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: appWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => payment(totalpay: totalPrice,)));
                                  },
                                  child: Text("Proceed to Pay", style: appWidget.colorboldText(20, Colors.white)),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // helper to compute subtotal: fetch current user's cart and product prices once
  Future<int> _computeSubtotalForCurrentUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return 0;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = userDoc.data() as Map<String, dynamic>? ?? {};
      List cartItems = data['cart'] ?? [];
      List<String> productIds = cartItems.map<String>((e) => (e['productId'] ?? '').toString()).where((id) => id.isNotEmpty).toList();
      if (productIds.isEmpty) return 0;

      final futures = productIds.map((id) =>
          FirebaseFirestore.instance
              .collection('admin')
              .doc('product')
              .collection('productCollection')
              .doc(id)
              .get()).toList();

      final docs = await Future.wait(futures);
      int subtotal = 0;
      for (int i = 0; i < cartItems.length; i++) {
        var item = cartItems[i];
        String pid = (item['productId'] ?? '').toString();
        int quantity = item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 0;
        final prodDoc = docs.firstWhere((d) => d.id == pid,);
        if (prodDoc != null && prodDoc.exists) {
          var pData = prodDoc.data() as Map<String, dynamic>? ?? {};
          double priceDouble = double.tryParse(pData['price']?.toString() ?? '0') ?? 0.0;
          int priceInt = priceDouble.round();
          subtotal += priceInt * quantity;
        }
      }
      return subtotal;
    } catch (e) {
      debugPrint('Error computing subtotal: $e');
      return 0;
    }
  }
}
