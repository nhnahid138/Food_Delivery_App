import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/widget_helper.dart';
import 'package:intl/intl.dart';

import 'graph.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  String selectedValue='DAILY';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
            children: [
              Container(
                color: Colors.pink[900],
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(top: 35,left: 10,right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (asyncSnapshot.connectionState == ConnectionState.waiting || !asyncSnapshot.hasData) {
                            return Center(
                              child:CircularProgressIndicator(),
                            );
                          }
                          final userData = asyncSnapshot.data!.data() as Map<String, dynamic>;
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(userData['photoURL']),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${userData['name']}',style: appWidget.colorboldText(20, Colors.white),),
                                  Text(userData['position'],style: appWidget.colorboldText(13, Colors.white70),),
                                ],
                              )
                            ],
                          );
                        }
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Text('Seller DashBoard',style: appWidget.colorboldText(20, Colors.white),),
                          SizedBox(width: 20,),
                          DropdownButton(
                              dropdownColor: Colors.pink[800],
                            style: appWidget.colorboldText(15, Colors.white),

                            value: selectedValue,
                              items: [
                                DropdownMenuItem(value: "DAILY", child: Text("DAILY")),
                                DropdownMenuItem(value: "WEEKLY", child: Text("WEEKLY")),
                                DropdownMenuItem(value: "MONTHLY", child: Text("MONTHLY")),
                                DropdownMenuItem(value: "YEARLY", child: Text("YEARLY")),
                                DropdownMenuItem(value: "LIFETIME", child: Text("LIFETIME")),
                              ],
                              onChanged: (value){
                                setState(() {
                                  selectedValue=value!;
                                });
                              })
                        ],
                      ),
                      SizedBox(height: 10,),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                              .collection('admin')
                              .doc('order')
                              .collection('userOrder')
                              .snapshots(),

                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          int totalEarning=0;
                          int sales=0;
                          int shipped=0;
                          int processing=0;
                          final documents = asyncSnapshot.data!.docs;
                          for(int i=0;i<documents.length;i++){

                            if(selectedValue=='DAILY'){
                              Timestamp timestamp = documents[i]['date'];
                              DateTime dateTime = timestamp.toDate();
                              String orderDate = DateFormat('yyyy-MM-dd').format(dateTime);

                              DateTime today=DateTime.now();
                              String todayDate = DateFormat('yyyy-MM-dd').format(today);
                              if(orderDate==todayDate){
                                if(documents[i]['status']=='Delivered'){
                                  int total=documents[i]['total'];
                                  totalEarning= totalEarning+total;

                                }
                                if(documents[i]['status']=='processing'){
                                  int total=documents[i]['total'];
                                  processing= processing+total;

                                }
                                if(documents[i]['status']=='Shipped'){
                                  int total=documents[i]['total'];
                                  shipped= shipped+total;

                                }

                                sales=processing+shipped;




                              }








                            }
                            if(selectedValue=='WEEKLY'){
                              Timestamp timestamp = documents[i]['date'];
                              DateTime dateTime = timestamp.toDate();
                              String orderDate = DateFormat('yyyy-MM-dd').format(dateTime);
                              for(int j=0;j<7;j++){

                              DateTime today=DateTime.now();
                              String todayDate = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: j)));
                             // String todayDate = DateFormat('yyyy-MM-dd').format(today);
                              if(orderDate==todayDate){
                                if(documents[i]['status']=='Delivered'){
                                  int total=documents[i]['total'];
                                  totalEarning= totalEarning+total;

                                }
                                if(documents[i]['status']=='processing'){
                                  int total=documents[i]['total'];
                                  processing= processing+total;

                                }
                                if(documents[i]['status']=='Shipped'){
                                  int total=documents[i]['total'];
                                  shipped= shipped+total;

                                }

                                sales=processing+shipped;




                              }








                            }
                            }
                            if(selectedValue=='MONTHLY'){
                              Timestamp timestamp = documents[i]['date'];
                              DateTime dateTime = timestamp.toDate();
                              String orderDate = DateFormat('yyyy-MM-dd').format(dateTime);
                              for(int j=0;j<30;j++){

                                DateTime today=DateTime.now();
                                String todayDate = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: j)));
                                // String todayDate = DateFormat('yyyy-MM-dd').format(today);
                                if(orderDate==todayDate){
                                  if(documents[i]['status']=='Delivered'){
                                    int total=documents[i]['total'];
                                    totalEarning= totalEarning+total;

                                  }
                                  if(documents[i]['status']=='processing'){
                                    int total=documents[i]['total'];
                                    processing= processing+total;

                                  }
                                  if(documents[i]['status']=='Shipped'){
                                    int total=documents[i]['total'];
                                    shipped= shipped+total;

                                  }

                                  sales=processing+shipped;




                                }








                              }
                            }
                            if(selectedValue=='YEARLY'){
                              Timestamp timestamp = documents[i]['date'];
                              DateTime dateTime = timestamp.toDate();
                              String orderDate = DateFormat('yyyy-MM-dd').format(dateTime);
                              for(int j=0;j<365;j++){

                                DateTime today=DateTime.now();
                                String todayDate = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: j)));
                                // String todayDate = DateFormat('yyyy-MM-dd').format(today);
                                if(orderDate==todayDate){
                                  if(documents[i]['status']=='Delivered'){
                                    int total=documents[i]['total'];
                                    totalEarning= totalEarning+total;

                                  }
                                  if(documents[i]['status']=='processing'){
                                    int total=documents[i]['total'];
                                    processing= processing+total;

                                  }
                                  if(documents[i]['status']=='Shipped'){
                                    int total=documents[i]['total'];
                                    shipped= shipped+total;

                                  }

                                  sales=processing+shipped;




                                }








                              }
                            }
                            if(selectedValue=='LIFETIME'){

                                // String todayDate = DateFormat('yyyy-MM-dd').format(today);
                                  if(documents[i]['status']=='Delivered'){
                                    int total=documents[i]['total'];
                                    totalEarning= totalEarning+total;

                                  }
                                  if(documents[i]['status']=='processing'){
                                    int total=documents[i]['total'];
                                    processing= processing+total;

                                  }
                                  if(documents[i]['status']=='Shipped'){
                                    int total=documents[i]['total'];
                                    shipped= shipped+total;

                                  }

                                  sales=processing+shipped;














                            }




                            // if(documents[i]['status']=='Delivered'){
                            //   int total=documents[i]['total'];
                            //   totalEarning= totalEarning+total;
                            //
                            // }
                            // if(documents[i]['status']=='processing'){
                            //   int total=documents[i]['total'];
                            //   processing= processing+total;
                            //
                            // }
                            // if(documents[i]['status']=='Shipped'){
                            //   int total=documents[i]['total'];
                            //   shipped= shipped+total;
                            //
                            // }
                            //
                            //  sales=processing+shipped;
                            //
                            //


                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Material(
                                      elevation: 5,
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: Container(
                                        padding: EdgeInsets.only(right: 10),
                                        //color: Colors.white24,
                                        height: 60,
                                        width: 180,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              // height: 40,
                                              // width: 40,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Icon(Icons.stacked_line_chart,size: 30,),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Total Earning',style: appWidget.colorboldText(15, Colors.white),),
                                                //SizedBox(height: 5,),
                                                Text('TK $totalEarning',style: appWidget.colorboldText(18, Colors.white),),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Material(
                                      elevation: 5,
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: Container(
                                        padding: EdgeInsets.only(right: 10),
                                        //color: Colors.white24,
                                        height: 60,
                                        width: 180,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              // height: 40,
                                              // width: 40,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Icon(Icons.bar_chart,size: 30,),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Total Sales',style: appWidget.colorboldText(15, Colors.white),),
                                                //SizedBox(height: 5,),
                                                Text('TK $sales',style: appWidget.colorboldText(18, Colors.white),),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )



                                  ],
                                ),

                            SizedBox(height:15 ,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Material(
                                  elevation: 5,
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    //color: Colors.white24,
                                    height: 60,
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Colors.white,
                                          ),
                                          // height: 40,
                                          // width: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.pending_actions,size: 30,),
                                          ),
                                        ),
                                         SizedBox(width: 10,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('In Processing',style: appWidget.colorboldText(15, Colors.white),),
                                            //SizedBox(height: 5,),
                                            Text('TK $processing',style: appWidget.colorboldText(18, Colors.white),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Material(
                                  elevation: 5,
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    //color: Colors.white24,
                                    height: 60,
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Colors.white,
                                          ),
                                          // height: 40,
                                          // width: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons.fire_truck,size: 30,),
                                          ),
                                        ),
                                         SizedBox(width: 10,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Shipped',style: appWidget.colorboldText(15, Colors.white),),
                                            //SizedBox(height: 5,),
                                            Text('TK $shipped',style: appWidget.colorboldText(18, Colors.white),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )



                              ],
                            )
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.55,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                    )
                  ),

                  child: SingleChildScrollView(child: Container(
                    padding: EdgeInsets.all(8),
                      child: SalesGraphWidget())),



                ),
              )
            ],
          )
    );


  }
}
