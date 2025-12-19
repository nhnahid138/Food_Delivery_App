import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/adminApp/adminBottomNev.dart';
import 'package:food/pages/cart.dart';
import 'package:food/pages/widget_helper.dart';





class adminorder extends StatefulWidget {
  const adminorder({super.key});

  @override
  State<adminorder> createState() => _adminorderState();
}

class _adminorderState extends State<adminorder> {

  Color status(String s){
    if(s=='processing'){
      return Colors.orange;
    }
    if(s=='Shipped'){
      return Colors.green;
    }
    if(s=='Cancelled'){
      return Colors.red;
    }
    if(s=='Delivered'){
      return Colors.blue;
    }else{
      return Colors.grey;
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => adminBottomNev()));
          },
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin')
          .doc('order').collection('userOrder').snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Text('Error = ${asyncSnapshot.error}');
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          QuerySnapshot querySnapshot = asyncSnapshot.data!;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;



          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                index=documents.length-1-index;
                bool isShipped=false;
                bool isDelivered=false;
                bool isCanceled=false;
                QueryDocumentSnapshot document = documents[index];
                List items= document['items'];
                if(document['status']=='Shipped'){
                  isShipped=true;
                }
                if(document['status']=='Delivered'||document['status']=='Cancelled'){
                  isDelivered=true;
                }
                if(document['status']=='Cancelled'){
                  isCanceled=true;

                }



              return Padding(
                padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                child: Material(
                  borderRadius:BorderRadius.circular(20),

                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(document['orderId'],style: appWidget.colorboldText(20, Colors.pink[900]!,),),
                                Material(
                                  elevation: 5,
                                  shadowColor: Colors.blue,
                                  color: status(document['status']),
                                  borderRadius: BorderRadius.circular(20),

                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${document['status']}',style: appWidget.colorboldText(10, Colors.white),),
                                    ),
                                  ),
                                )

                              ],
                            )),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(

                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                    itemBuilder:(context,index){
                                      Map<String, dynamic> item=items[index];
                                      String productId=item['productId'];
                                      int quantity=item['quantity'];


                                      return StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance.collection('admin')
                                          .doc('product').collection('productCollection').doc(productId).snapshots(),
                                        builder: (context, asyncSnapshot) {
                                          if (asyncSnapshot.hasError) {
                                            return Text('Error = ${asyncSnapshot.error}');
                                          }
                                          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          DocumentSnapshot document = asyncSnapshot.data!;
                                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;








                                          return Row(
                                            children: [
                                              Image.network(data['image'],fit: BoxFit.cover,height: 30,width: 30,)
                                              ,SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data['title'],style: appWidget.colorboldText(15, Colors.black,),),
                                                  Text('Price: ${data['price']} TK  Qty: $quantity'),
                                                ],
                                              )
                                            ],
                                          );
                                        }
                                      );

                                    }
                                    ),
                              ),

                              // Container(
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10)),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text(' ${document['name']}'),
                              //       Text(' ${document['phone']}'),
                              //       Text('${document['address']}'),
                              //       //Text('date: ${document['date']}'),
                              //     ],
                              //   ),


                             // )
                              // Column(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     SizedBox(height: 10,),
                              //    isShipped?
                              //    Material(
                              //      elevation: 5,
                              //      borderRadius: BorderRadius.circular(20),
                              //      child: Container(
                              //        child: Padding(
                              //          padding: const EdgeInsets.all(8.0),
                              //          child: Text(' Mark As Delivereddd',style: appWidget.colorboldText(8, Colors.pink[900]!),),
                              //        ),
                              //
                              //      ),
                              //    ):
                              //    Material(
                              //       elevation: 5,
                              //       color: Colors.green,
                              //       borderRadius: BorderRadius.circular(20),
                              //       child: Container(
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Text('mark as Shipdddped',style: appWidget.colorboldText(8, Colors.white),),
                              //         ),
                              //
                              //       ),
                              //     ),
                              //
                              //   ],
                              // )
                            ],
                          ),

                        ),
                        SizedBox(height: 10,),
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5,right: 5),
                            child: Text('Total Price: ${document['total']} TK',style: appWidget.colorboldText(15, Colors.black),),
                          ),
                        ),

                        Column(
                          children: [
                            isDelivered?
                            Material(
                              elevation: 5,
                              color:isCanceled?Colors.red: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      isCanceled?
                                  Text('Order Cancelled',style: appWidget.colorboldText(10, Colors.white),):

                                  Text('Successfully Delivered',style: appWidget.colorboldText(10, Colors.white),),
                                ),

                              ),
                            ):
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [


                                isShipped?Material(
                                  elevation: 5,
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                  child: GestureDetector(
                                    onTap: (){
                                      FirebaseFirestore.instance.collection('admin')
                                          .doc('order').collection('userOrder').doc(document.id)
                                          .update({
                                        'status': 'Delivered',
                                      });
                                      FirebaseFirestore.instance.collection('users')
                                          .doc(document['userId']).collection('orders').doc(document.id)
                                          .update({
                                        'status': 'Delivered',
                                      });

                                    },

                                    child: Container(
                                      alignment: Alignment.center,
                                      width: (MediaQuery.of(context).size.width/2)-25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Mark as Delivered',style: appWidget.colorboldText(10, Colors.white),),
                                      ),

                                    ),
                                  ),
                                ):
                                Material(
                                  elevation: 5,
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                  child: GestureDetector(
                                    onTap: (){
                                      FirebaseFirestore.instance.collection('admin')
                                          .doc('order').collection('userOrder').doc(document.id)
                                          .update({
                                        'status': 'Shipped',
                                      });
                                      FirebaseFirestore.instance.collection('users')
                                          .doc(document['userId']).collection('orders').doc(document.id)
                                          .update({
                                        'status': 'Shipped',
                                      });

                                    },

                                    child: Container(
                                      alignment: Alignment.center,
                                      width: (MediaQuery.of(context).size.width/2)-25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Mark as Shipped',style: appWidget.colorboldText(10, Colors.white),),
                                      ),

                                    ),
                                  ),
                                ),
                                GestureDetector(

                                  onTap: (){
                                    FirebaseFirestore.instance.collection('admin')
                                        .doc('order').collection('userOrder').doc(document.id)
                                        .update({
                                      'status': 'Cancelled',
                                    });
                                    FirebaseFirestore.instance.collection('users')
                                        .doc(document['userId']).collection('orders').doc(document.id)
                                        .update({
                                      'status': 'Cancelled',
                                    });

                                  },



                                  child: Material(
                                    elevation: 5,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: (MediaQuery.of(context).size.width/2)-25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Cancel Order',style: appWidget.colorboldText(10, Colors.white),),
                                      ),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7,),
                            Material(
                              elevation: 5,
                              color: Colors.pink[900],
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Order Full Details',style: appWidget.colorboldText(10, Colors.white),),
                                ),

                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        }
      )
    );
  }
}
