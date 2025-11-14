import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'package:food/pages/cart.dart';
import 'package:food/pages/database.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/order.dart';
import 'package:food/pages/user_order.dart';
import 'package:food/pages/widget_helper.dart';

class payment extends StatefulWidget {
  int totalpay;
   payment({super.key, required this.totalpay});

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  bool isBkash=false;
  bool isNogod=false;
  bool isUpae=false;
  bool isVisa=false;
  bool isCash=false;
  bool isEdit=false;
  bool isSaving = false;
  bool isLoaded=false;
  String?phone;
  String?name;
  String?address;
  List? orderItem;
  num? orderId;
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    getUserData();
    productDetails();
  }
  Future<void> productDetails()async{
    DocumentSnapshot poc= await FirebaseFirestore.
    instance.collection('admin').doc('order').get();
    setState(() {
      var data = poc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
      orderId=data['orderId'];

    });

  }



  Future<void> getUserData() async {
    DocumentSnapshot doc=await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    var data = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
    setState(() {
      name = data['name'] ?? '';
      phone = data['phone'] ?? '';
      address = data['address'] ?? '';
      nameController.text = data['name'] ?? '';
      phoneController.text = data['phone'] ?? '';
      addressController.text = data['address'] ?? '';
      orderItem = data['cart'] ?? [];
    });

  }
  bool isLoading=false;



  String selectedPayment='img/up.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Payment"),
          centerTitle: true,
        ),
        body:
        Container(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child:  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Stack(
                                              children: [
                
                                                Container(
                                                    margin: EdgeInsets.only(top: 15),
                                                    child: Icon(CupertinoIcons.map_fill)),
                                                Icon(CupertinoIcons.location_solid,color: Colors.redAccent,),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Shiping Information: ",style: appWidget.boldText(25),),
                                                isEdit?SizedBox(height: 10,):SizedBox(),
                                                isEdit?TextField(
                                                  controller: nameController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Name',
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(20)),)
                                                  ),
                                                ):Text(name!??'',style: appWidget.boldText(20),),
                                                isEdit?SizedBox(height: 10,):SizedBox(height: 5,),
                                                isEdit?TextField(
                                                  controller: phoneController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Phone',
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(20)),)
                                                  ),
                                                ):Text("Phone: $phone",style: appWidget.boldText(15),),
                                                isEdit?SizedBox(height: 10,):SizedBox(height: 5,),
                                                isEdit?TextField(
                                                  controller: addressController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Address',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    ),
                                                  ),
                                                ):Text("Address: $address",style: appWidget.boldText(15),),
                
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                
                
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    if(isEdit==false){
                                      isLoaded=true;
                                      isEdit=true;
                                      isSaving=true;
                                      setState(() {
                                        getUserData();
                                      });


                                    }else if(isEdit==true){
                                      setState(() {
                                        name= nameController.text;
                                        phone= phoneController.text;
                                        address= addressController.text;
                                      });



                                      try {
                                        FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                          'name': nameController.text,
                                          'phone': phoneController.text,
                                          'address': addressController.text,
                                        });
                                        if (!mounted) return;
                                        setState(() {
                                          isEdit=false;
                                          //name = newName;
                                        });
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to save: $e')),
                                        );
                                      } finally {
                                        if (!mounted) return;
                                        setState(() => isSaving = false);
                                      }





                                    }
                                  });
                                },
                                child: isEdit?Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 60,
                                  child: Text('save',style: appWidget.colorboldText(15,Colors.deepPurple),),
                                ):Container(
                                    height: 40,
                                    width: 40,
                                    child: isSaving?CircularProgressIndicator():Icon(Icons.edit_location_alt_rounded,color: Colors.deepPurple,)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 120,
                          child: Image.asset('img/locd.png',fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                
                
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Select A Payment Method:",style: appWidget.boldText(20),),
                      SizedBox(height: 10,),
                
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isBkash=true;
                                      isNogod=false;
                                      isUpae=false;
                                      isVisa= false;
                                      isCash=false;
                                      selectedPayment='img/bkas.png';
                                    });
                                  },
                                  child: Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(10),
                                    color: isBkash?Colors.deepPurple:Colors.white,
                                    child: Container(
                                      height: isBkash?80:65,
                                      width: isBkash?80:65,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('img/bkas.png',color: isBkash?Colors.white:null,),
                                      ),
                
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Bkash",style: appWidget.boldText(isBkash?25:15),)
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      isBkash=false;
                                      isNogod=true;
                                      isUpae=false;
                                      isVisa= false;
                                      isCash=false;
                                      selectedPayment='img/nogo.png';
                                    });
                                  },
                                  child: Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(10),
                                    color: isNogod?Colors.deepPurple:Colors.white,
                                    child: Container(
                                      height: isNogod?80:65,
                                      width: isNogod?80:65,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('img/nogo.png',color: isNogod?Colors.white:null),
                                      ),
                
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Nogod",style: appWidget.boldText(isNogod?25:15))
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      isBkash=false;
                                      isNogod=false;
                                      isUpae=true;
                                      isVisa= false;
                                      isCash=false;
                                      selectedPayment='img/upa.png';
                                    });
                
                                  },
                                  child: Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(10),
                                    color: isUpae?Colors.deepPurple:Colors.white,
                                    child: Container(
                                      height: isUpae?80:65,
                                      width: isUpae?80:65,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('img/upa.png',color: isUpae?Colors.white:null),
                                      ),
                
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Upae",style: appWidget.boldText(isUpae?25:15),)
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      isBkash=false;
                                      isNogod=false;
                                      isUpae=false;
                                      isVisa= true;
                                      isCash=false;
                                      selectedPayment='img/vsaa.png';
                                    });
                                  },
                
                                  child: Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(10),
                                    color: isVisa?Colors.deepPurple:Colors.white,
                                    child: Container(
                                      height: isVisa?80:65,
                                      width: isVisa?80:65,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('img/vsaa.png',color: isVisa?Colors.white:null),
                                      ),
                
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Visa",style: appWidget.boldText(isVisa?25:15),)
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      isBkash=false;
                                      isNogod=false;
                                      isUpae=false;
                                      isVisa= false;
                                      isCash=true;
                                      selectedPayment='img/codd.png';
                                    });
                                  },
                                  child: Material(
                                    elevation:5,
                                    borderRadius: BorderRadius.circular(10),
                                    color: isCash?Colors.deepPurple:Colors.white,
                                    child: AnimatedContainer(
                                      height: isCash?80:65,
                                      width: isCash?80:65,
                                      duration: Duration(seconds: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('img/codd.png',color: isCash?Colors.white:null),
                                      ),
                
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Cash",style: appWidget.boldText(isCash?25:15),)
                              ],
                            ),
                
                
                
                
                          ],
                        ),
                      ),
                
                
                
                
                
                    ],
                  ),
                ),
              ),

            ],),
        ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 122,
        child:  Container(


          height: 120,
          width: MediaQuery.of(context).size.width,

          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text("Total Pay: ",style: appWidget.colorboldText(20, Colors.black),),
                        Text("${widget.totalpay} TK",style: appWidget.colorboldText(20, Colors.black),),
                      ],
                    ),
                    Text("(Included Tax And Fees)",style: appWidget.subText(15),),
                    Text("Delivery Time: 30 min",style: appWidget.subText(15),),

                  ],
                ),
                Column(
                  children: [
                    Row(

                      children: [
                        Text("Pay With: ",style: appWidget.colorboldText(15, Colors.deepPurple),),
                        Container(

                          height: 40,
                          width: 40,
                          child: Image.asset('$selectedPayment'??'img/up.png'),
                        ),
                      ],
                    ),
                    ElevatedButton(onPressed: () async {
                      try{
                        setState(() {
                          isLoading=true;
                        });

                        await FirebaseFirestore.instance.collection('admin').doc('order').update({
                          'orderId': orderId! +1,
                        });
                        String uniqueOrderId = '#QFD${(orderId!+1).toString()}';




                        // Reference to the userOrders subcollection
                        final adminOrderRef = FirebaseFirestore.instance
                            .collection('admin')
                            .doc('order')
                            .collection('userOrder');

// Generate a unique order ID (optional)
                        final newOrderRef = adminOrderRef.doc(uniqueOrderId); // auto ID
                        final orderid = newOrderRef.id;

// Save order data
                        await newOrderRef.set({
                          'orderId': orderid,
                          'items': orderItem,
                          'status': 'processing',
                          'total': widget.totalpay,
                          'paymentMethod': selectedPayment,
                          'name': name,
                          'phone': phone,
                          'address': address,
                          'date': DateTime.now(),
                          'userId': user!.uid,
                        });
















                        await FirebaseFirestore.instance.collection('users')
                            .doc(user!.uid)
                        .collection('orders')
                        .doc(uniqueOrderId)
                        .set({
                          'items': orderItem,
                          'status': 'processing',
                          'total': widget.totalpay,
                          'paymentMethod': selectedPayment,
                          'name': name,
                          'phone': phone,
                          'address': address,
                          'orderId': uniqueOrderId,
                          'date': DateTime.now(),
                          'shippedTime':null,
                        });
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save: $e')),
                        );
                      }finally{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>userOrder()));

                        setState(() {
                          isLoading=false;

                        });

                      }

                      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                        'cart': [],
                      });

                    }, child: isLoading?CircularProgressIndicator(
                      color: Colors.white,
                    ):Text("Confirm Order"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(5),



                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }}







