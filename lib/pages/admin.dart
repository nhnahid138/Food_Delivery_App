import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {

  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController discription = TextEditingController();
  String? category;
  String? image;
  File? previewImg;
  bool imageloading=false;
  bool done=false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadImg() async {

    try {
      setState(() {
        imageloading=true;
      });
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) {
        print('No image selected');
        return;
      }

      File imageFile = File(pickedImage.path);
      previewImg = imageFile;


      const cloudName = 'dmpyzazve';
      const uploadPreset = 'unsigned_upload';

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        setState(() {
          image = data['secure_url'];

        });


      } else {
        print(' Upload failed: ${response.statusCode}');
        print(resBody);
      }
    } catch (e) {
      print(' Error uploading: $e');
    }finally{
      setState(() {
        imageloading=false;
      });
    }
  }

  Future<void> addItem()async{

    DocumentSnapshot product= await FirebaseFirestore.instance.collection('admin').doc('product').get();
    var data = product.data() as Map<String, dynamic>? ?? <String, dynamic>{};
    int id=data['pid']??0;
    String productId='#pid${id+1}';
    try{
      await FirebaseFirestore.instance.collection('admin').doc('product')
          .collection('productCollection').doc(productId).set({
        'title': title.text,
        'subtitle': subtitle.text,
        'price': price.text,
        'image': image,
        'category': category,
        'discription': discription.text,
        'productId': productId,



      });

      await FirebaseFirestore.instance.collection('admin').doc('product').update({
        'pid': id+1,
      });
      
      
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding document: $e'),
          duration: Duration(seconds: 2),
        ),
      );

    }finally{
      setState(() {
        done=true;

      });
    }





  }




  Future<void> addFirestore() async {
    try {
      await _firestore.collection('admin').doc('product').update({
        'item': FieldValue.arrayUnion([
          {
            'title': title.text,
            'subtitle': subtitle.text,
            'price': price.text,
            'image': image,
            'category': category,
            'discription': discription.text,
          }
        ]),
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Stack(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 35,left: 65),
                child: Text('ADD ITEM',style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),)),
            alignment: Alignment.topLeft,
          color: Colors.pink[900],
          height: MediaQuery.of(context).size.height/2,
        ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.5,),
            alignment: Alignment.bottomCenter,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),

            ),
          ),


          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 110,left: 25),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  //color: Colors.amberAccent,
                  alignment: Alignment.center,
              
                  //height: 550,
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: title,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            //hintText: "Title",
                            label: Text("Title"),
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          controller: subtitle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),),
                            label: Text("Subtitle"),
                          ),
              
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          controller: price,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),),
                            label: Text("Price"),
                          ),
                        ),
                        SizedBox(height: 20,),
                        DropdownMenu(
                          onSelected: (value){
                            setState(() {
                              category=value;
              
                            });
                          },
                          label: Text("Select a Category"),
                            width: 400,
              
              
                            dropdownMenuEntries:<DropdownMenuEntry<String>> [
                          DropdownMenuEntry<String>(
                              value: 'icecream',
                              label: 'Ice-Cream'),
              
                          DropdownMenuEntry<String>(value: 'salad', label: 'Salad'),
                          DropdownMenuEntry<String>(value: 'burger', label: 'Burger'),
                              DropdownMenuEntry<String>(value: 'pizza', label: 'pizza'),
                        ]),
                        SizedBox(height: 20,),
                        Container(
                          height: 120,
                          child: TextField(
                            controller: discription,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
              
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),),
                              label: Text("Discription"),
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 5,
                          child: Container(
                            child: Stack(
                              children: [
                               imageloading?Center(child: CircularProgressIndicator()): image!=null?
                                Image.network(image!,height: 200,
                                  width: 200,fit: BoxFit.cover,
                                ):Text("Select a Image"),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(()async {
                                        setState(() {
                                          imageloading=true;
                                        });
                                        await uploadImg();
              
                                      });
              
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.pink[900],
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
                                      ),
              
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(CupertinoIcons.camera_fill,color: Colors.white,),
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ,
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.pink[900]!,
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: () async {
                          if(title.text.isEmpty||
                              subtitle.text.isEmpty||
                              price.text.isEmpty||
                              category==null||
                              image==null
                          ){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill all the fields'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }else{

                           await addItem();
              
              
                          //await addFirestore();
                         title.clear();
                         subtitle.clear();
                         price.clear();
                          discription.clear();
                          setState(() {
                            image=null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item Added'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                           }
              
                        }, child: Text("Publish")),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),]
      ),

    );
  }
}
