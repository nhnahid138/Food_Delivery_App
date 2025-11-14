import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/bottom_nevigation.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/widget_helper.dart';
int? quantity;

class pDetails extends StatefulWidget {
  final String? productId;
  const pDetails({super.key, this.productId});

  @override
  State<pDetails> createState() => _DetailsState();
}

class _DetailsState extends State<pDetails> {
  int count=1;
  String? pid;
  String? tk;
  int?tkTotal;
  Map? productData = {};
  bool isAdded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getProduct();
    pid=widget.productId;

  }
 // Future< void> getProduct()async{
 //     var product = await FirebaseFirestore.instance.collection('admin')
 //        .doc('product')
 //        .collection('productCollection')
 //        .doc(widget.productId)
 //        .get();
 //    productData= product.data();
 //  }
 //
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admin')
            .doc('product')
            .collection('productCollection')
            .doc(widget.productId)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          var productData = asyncSnapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};
          return Stack(
                    children: [



                      Container(
                          margin: EdgeInsets.only(top: 50,left: 20,right: 20, bottom: 140),
                          child: SingleChildScrollView(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(productData['image'],
                                    height: 360,
                                    width: 360,
                                    fit: BoxFit.fill,),
                                ),
                                Row(
                                  children: [

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(productData['title'],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                        //Text(widget.productId!,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                        Text('TK ${productData['price']}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.blue),),

                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,

                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    if(count>1){ count--;}
                                                  });
                                                },
                                                child: Icon(CupertinoIcons.minus_circle_fill,size: 24,)),
                                            SizedBox(width: 10,),
                                            Text(" $count ",style: appWidget.boldText(24),),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    count++;
                                                  });
                                                },

                                                child: Icon(CupertinoIcons.plus_circle_fill,size: 24,)),
                                          ],
                                        ),


                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: 20,),
                                Container(
                                  height: 250,
                                  child: Text(productData['discription']??"Lorem Ipsum is simply dummy text of the printing and "
                                      "typesetting industry. Lorem Ipsum has been the "
                                      "industry's standard dummy text ever since the 1500s, "
                                      "when an unknown printer took a galley of type and scrambled "
                                      "it to make a type specimen book. It has survived not only"
                                      "typesetting industry. Lorem Ipsum has been the "
                                      "industry's standard dummy text ever since the 1500s, "
                                      "when an unknown printer took a galley of type and scrambled "
                                      "it to make a type specimen book. It has survived not only"
                                    ,style: appWidget.subText(15),),
                                ),
                                SizedBox(height: 10,),



                              ],
                            ),
                          )
                      ),
                      Container(

                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:20),
                              child: Row(
                                children: [
                                  Text("Delivery Time",style: appWidget.boldText(20),),
                                  SizedBox(width: 20,),
                                  Icon(CupertinoIcons.alarm,size: 20,color: Colors.black,),
                                  SizedBox(width: 5,),
                                  Text("30 min",style: appWidget.boldText(20),),
                                ],

                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10,right: 20,bottom: 10),

                              //color: Colors.blue,


                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text("Total Price",style:appWidget.boldText(24),),

                                        Text("TK ${int.parse(productData['price'])*count}",
                                          style:appWidget.boldText(24),),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(onPressed: ()async{
                                    var user=FirebaseAuth.instance.currentUser!;
                                    quantity=count;
                                    try{
                                      setState(() {
                                        isAdded=true;

                                      });

                                      await FirebaseFirestore.instance.collection('users')
                                          .doc(user.uid).update({
                                        'cart': FieldValue.arrayUnion([{
                                          'quantity':count,
                                          'productId': widget.productId}
                                        ]),

                                      });

                                    }catch(e){
                                      print(e);
                                    }finally{
                                      setState(() {
                                        isAdded=false;

                                      });

                                    }

                                    isAdded?null:ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("added to cart"),));



                                    isAdded? null: Navigator.push(context, MaterialPageRoute(builder: (context)=>bottomNev()));






                                  }, child: isAdded?CircularProgressIndicator(
                                    color: Colors.white,
                                  ):Text("Add to cart",style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),

                                    ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                    ]);
        }
      )




























































    );
  }
}
