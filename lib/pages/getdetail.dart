import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/admin.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/widget_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';

class getDetail extends StatefulWidget {
  const getDetail({super.key});

  @override
  State<getDetail> createState() => _getDetailState();
}

class _getDetailState extends State<getDetail> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _location = TextEditingController();
  String? image;
  File? previewImg;


  String name = "";

  @override
  void initState() {
    super.initState();
    // removed listener: use TextField.onChanged to update 'name' immediately
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  bool isloading=false;
  Future<void> uploadImg() async {

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) {
        print('No image selected');
        return;
      }

      File imageFile = File(pickedImage.path);
      previewImg = imageFile;


      const cloudName = 'dmpyzazve'; // your Cloudinary cloud name
      const uploadPreset = 'unsigned_upload'; // preset name (unsigned)

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
    }
  }
  User? user = FirebaseAuth.instance.currentUser;


  Future<void> addFirestore() async {
    try {
      setState(() {
        isloading=true;
      });
      await FirebaseFirestore.instance
          .collection('users').doc(user!.uid).set({
        'name': _nameController.text.trim(),
        'address': _location.text.trim(),
        'photoURL': image,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding document: $e'))
      );
    }finally{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details Saved Successfully'))
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));
      setState(() {
        isloading=false;


      });
    }
  }
  
  
  

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                //color: Colors.amber,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.indigo,
                        Colors.indigoAccent,
                      ],
                    )

                ),
                height: MediaQuery.of(context).size.height/2.5,
                // Removed Expanded here, just use Container with child
                child: Container(
                    margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height/2.5)/5.5),
                    alignment: Alignment.topCenter,
                    child: Image.asset('img/logo.png',height: 100,width: 350,)),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70),topRight: Radius.circular(70),
                  ),),
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.5),
                  child: GestureDetector(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));
                    },
                    child: Text("",
                      style: appWidget.colorboldText(18, Colors.blue),),
                  ),
                ),

              ),
              Container(
                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/5,
                  left: (screenWidth-(screenWidth/1.2))/2,
                ),
                //height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width/1.2,

                decoration: BoxDecoration(
                ),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        // greeting updates immediately as user types
                        Text("Welcome ${name}",
                          style: appWidget.colorboldText(20, Colors.black),),
                        SizedBox(height: 10,),
                        TextField(
                          controller: _nameController,
                          onChanged: (v) => setState(() => name = v),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: _location,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: 'Enter Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                            CircleAvatar(
                              radius: 100,
                              backgroundImage: image!=null?NetworkImage(image!):AssetImage('img/user.jpg'),
                              child: Container(
                                alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(()async {
                                        await uploadImg();

                                      });},
                                    child: Material(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(CupertinoIcons.camera_fill,color: Colors.deepPurple,),
                                        )),
                                  )),
                            ),

                        SizedBox(height: 20,),
                        Container(
                          width: 270,
                            child: ElevatedButton(onPressed: ()async{
                              await addFirestore();
                            }, child: isloading?CircularProgressIndicator():Text('Save') )),
                        
                        
                        
                        
                        
                        
                        

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
