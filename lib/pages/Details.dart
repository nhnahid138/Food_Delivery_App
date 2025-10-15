import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/widget_helper.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int count=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50,left: 20,right: 20),
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
            Image.asset("img/salad4.png",
              height: MediaQuery.of(context).size.height/2.5,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vegan Salad Bowl",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    Text("\$20",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.blue),),
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
              height: 200,
              child: SingleChildScrollView(
                child: Text("Lorem Ipsum is simply dummy text of the printing and "
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
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text("Delivery Time",style: appWidget.boldText(20),),
                SizedBox(width: 20,),
                Icon(CupertinoIcons.alarm,size: 20,color: Colors.black,),
                SizedBox(width: 5,),
                Text("30 min",style: appWidget.boldText(20),),
              ],
            ),
          ],
        )
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text("Total Price", style: appWidget.boldText(20),),
                Text("\$${20 * count}", style: appWidget.boldText(24),),

              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("Add to Cart",style: TextStyle(color: Colors.white,
                      fontSize: 20,fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(width: 5,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            CupertinoIcons.cart_fill,color: Colors.blueAccent,size: 15,),
                        ))
                  ],
                ),
              ),
            )
            //Text("\$${20 * count}", style: appWidget.boldText(24),),
          ],
        ),
      ),
    );
  }
}
