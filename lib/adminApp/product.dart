import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/admin.dart';
import 'package:food/pages/widget_helper.dart';

class product extends StatefulWidget {
  const product({super.key});

  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {
  String? selectedItemId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All products'),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>admin()));
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.pink[900],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      Container(
                        height: 30,width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,

                      ),
                      child: Icon(Icons.add_shopping_cart,color: Colors.pink[900],size: 20,),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Add New Product',style: appWidget.colorboldText(15, Colors.white),),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        //centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('admin')
              .doc('product').collection('productCollection').snapshots(),

          builder: (context, asyncSnapshot) {
            if (!asyncSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final snap = asyncSnapshot.data!.docs;


            return  ListView.builder(
                itemCount: snap.length,
                itemBuilder: (context,index) {
                  var snapOrder = snap[index];
                  TextEditingController titleController = TextEditingController();
                  TextEditingController subtitleController = TextEditingController();
                  TextEditingController priceController = TextEditingController();
                  TextEditingController discriptionController = TextEditingController();
                  final id=snapOrder.id;
                  bool isDetail = (selectedItemId == id);
                    titleController.text=snapOrder['title'];
                    subtitleController.text=snapOrder['subtitle'];
                    priceController.text=snapOrder['price'];
                    discriptionController.text=snapOrder['discription'];

                  return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
         //color: Colors.yellow,
          child: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(id,style: appWidget.colorboldText(20, Colors.pink[900]!),),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedItemId == id) {
                                          selectedItemId = '';
                                        }else{
                                          selectedItemId = id;
                                        }
                                      });
                                    },

                                      child: Image.network(snapOrder['image'],fit: BoxFit.cover,height: 80,width: 80,)),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        isDetail? TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                            labelText: 'Title',

                                          ),


                                        ):
                                        Text(snapOrder['title'],style: appWidget.colorboldText(20, Colors.black),),
                                        isDetail? TextField(
                                          controller: subtitleController,
                                          decoration: InputDecoration(
                                            labelText: 'Sub Title',

                                          ),


                                        ):
                                        Text(snapOrder['subtitle'],style: appWidget.subText(15),),
                                        isDetail? TextField(
                                          controller: priceController,
                                          decoration: InputDecoration(
                                             labelText: 'Price',

                                          ),


                                        ):
                                        Text('TK ${snapOrder['price']}',style: appWidget.colorboldText(20, Colors.black),),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                             isDetail? TextField(
                                controller: discriptionController,
                               keyboardType: TextInputType.multiline,
                               maxLines: null,
                               minLines: 1,
                               decoration: InputDecoration(
                                  labelText: 'Description',

                                ),


                              ):Container(),
                            ],
                          ),

                      )

                  ),
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                  color: Colors.pink[900],
                  elevation: 5,

                  child: isDetail?GestureDetector(
                    onTap: () {
                      if(snapOrder['title']!=titleController.text
                          || snapOrder['subtitle']!=subtitleController.text
                          || snapOrder['price']!=priceController.text
                          || snapOrder['discription']!=discriptionController.text
                      ){
                        FirebaseFirestore.instance.collection('admin').doc('product').collection('productCollection').doc(id).update({
                          'title':titleController.text,
                          'subtitle':subtitleController.text,
                          'price':priceController.text,
                          'discription':discriptionController.text,
                        });

                      }
                      setState(() {
                          selectedItemId = '';

                      });
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Save',style: appWidget.colorboldText(15, Colors.white),),
                      ),
                    ),
                  ):GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedItemId == id) {
                          selectedItemId = '';
                        }else{
                          selectedItemId = id;
                        }
                      });
                    },
                    child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Edit',style: appWidget.colorboldText(15, Colors.white),),
                    ),
                                  ),
                  ),
                ),)
            ],
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
