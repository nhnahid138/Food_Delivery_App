import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/cart.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/theme.dart';
import 'package:food/pages/widget_helper.dart';

import 'Details.dart';







int? selectedDetailIndex;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isproductLoading=false;
  String? email;
  String? name;
  String? imageUrl;
  String? address;
  List? items=[];
  String? selectedCategory;


  @override
  void initState() {
    super.initState();
    fetchData();
    productDetails();
  }
  Future<void> productDetails()async{

    try{
    setState(() {
      isproductLoading=true;
    });
    DocumentSnapshot poc= await FirebaseFirestore.
    instance.collection('admin').doc('product').get();
    setState(() {
      var data = poc.data() as Map<String, dynamic>? ?? <String, dynamic>{};
      items = data['item'] ?? [];

    });

    }catch(e){
      print("Error fetching product details: $e");
    }finally{
      setState(() {
        isproductLoading=false;
      });
    }


  }
  List? selectedItems=[0,1,2,3,4];

  Future<void> selected() async {
    selectedItems=[];
    for(int i=0;i<items!.length;i++){
      var item=items![i];
      if(item['category']==selectedCategory){
      setState(() {
        selectedItems!.add(i);

      });

      }
    }

  }








  Future<void> fetchData()async{
    try{
      User? user = _auth.currentUser;
      if(user!=null){
        DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userData=doc.data() as Map<String, dynamic>?;
          isLoading=false;
          email=userData?['email'] ?? 'No Email';
          name=userData?['name'] ?? 'No Name';
          imageUrl=userData?['photoURL'] ?? '';
          address=userData?['address'] ?? '';
          

        });


      }

    }catch (e) {
      setState(() => isLoading = false);
      print("Error fetching user data: $e");
    }
  }





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
                    isLoading?CircularProgressIndicator():
                    Flexible(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(imageUrl!),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$name",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                                ,),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.location_solid,size: 15,color: Colors.red,),
                                  SizedBox(width: 5,),
                                  Text("$address",style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    )),
                                ],
                              )
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>cart()));},
                      child: Container(
                        decoration: BoxDecoration(
                          color:Colors.indigo[900],
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
                          selectedCategory="icecream";
                          selected();
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:icecream?Colors.indigo[900]:Colors.white,
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
                          selectedCategory="pizza";
                          selected();
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:pizza?Colors.indigo[900]:Colors.white,
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
                          selectedCategory="salad";
                          selected();
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:salad?Colors.indigo[900]:Colors.white,
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
                          selectedCategory="burger";
                          selected();
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color:burger?Colors.indigo[900]:Colors.white,
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
              Text('Popular Now',style: appWidget.boldText(22),),
              isproductLoading?Container(
                height: 250,
                alignment: Alignment.center, width: MediaQuery.of(context).size.width,
                  child: CircularProgressIndicator(color: Colors.red,

              )):SizedBox(
                height: 280,
                child: ListView.builder(
                   // scrollDirection: Axis.horizontal,
                  scrollDirection: Axis.horizontal,
                  itemCount:selectedItems!.length,
                  itemBuilder: (context,index) {
                    var item=items![selectedItems![index]];
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedDetailIndex=selectedItems![index];

                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            margin: EdgeInsets.only(right: 20,left: 20,top: 10,bottom: 10),
                            //color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(item['image'],height: 150,
                                width: 150,fit: BoxFit.fill,),
                                Column(
                                 // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['title'],style:appWidget.boldText(20),),
                                    Text(item['subtitle'],style: appWidget.subText(15),),
                                    Text("TK ${item['price']}",style: appWidget.boldText(20),)

                                  ],
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    );




                  }
                ),
              ),
              StreamBuilder<DocumentSnapshot>(stream: FirebaseFirestore.instance.collection('admin')
                  .doc('product').snapshots(),
                  builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);}
                var data=snapshot.data!.data() as Map<String,dynamic>;
                List items=data['item'];
                return ListView.builder(
                  itemCount:items.length ,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), 
                  itemBuilder: (BuildContext context, int index) {
                    var item=items[index];
                    return GestureDetector(
                        onTap:(){
                          setState(() {
                            selectedDetailIndex=index;
                          });
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
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.network(item['image'],
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,),
                                  ),
                                  SizedBox(width: 20,),
                                  Container(
                                      height: 130,
                                      width: 170,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['title'],style: appWidget.boldText(20),),
                                          Text(item['subtitle'],style: appWidget.subText(15),),
                                          Text('TK ${item['price']}',style: appWidget.boldText(20),),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );














                  },
                );

                  })

              
            ],
          ),
        ),
      ),
    );
  }
}
