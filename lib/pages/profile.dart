import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/admin.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/user_order.dart';
import 'package:food/pages/widget_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? name;
  bool isEditing=false;
  TextEditingController nameController=TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.location_on,color: Colors.red),
                title: const Text('Kuril Bissowroad,Dhaka'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone,color: Colors.green),
                title: const Text('01770855830'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mail,color: Colors.blue),
                title: const Text('nhnahid138@gmail.com'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }















  Future<void> uploadImg() async {
    User? user = _auth.currentUser;
    String uid = user!.uid;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) {
        print('No image selected');
        return;
      }

      File imageFile = File(pickedImage.path);

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
        String imageu =data['secure_url'];
        await _firestore.collection('users').doc(uid).update({
          'photoURL': imageu,
        });
      } else {
        print('❌ Upload failed: ${response.statusCode}');
        print(resBody);
      }
    } catch (e) {
      print('🔥 Error uploading: $e');
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
          name=userData?['name'] ?? 'not set';
          nameController.text = name ?? '';
        });


      }

    }catch (e) {
      setState(() => isLoading = false);
      print("Error fetching user data: $e");
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>admin()));
      },
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        child: Icon(Icons.add_shopping_cart_sharp,color: Colors.white,),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              elevation: 5,
              child: Container(height: 310,
                margin: EdgeInsets.only(top:50),
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return GestureDetector(
                            onTap: () => uploadImg(),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('img/user.jpg'),
                            ),
                          );
                        }
        
                        // Safely read document data (DocumentSnapshot.data() returns Map?)
                        final doc = snapshot.data!;
                        final data = doc.data() as Map<String, dynamic>? ?? {};
                        // Accept either 'photoURL' (used by uploadImg) or 'photoUrl' if present
                        final String? photoUrl = (data['photoURL'] as String?) ?? (data['photoUrl'] as String?);
        
                        return GestureDetector(
                          onTap: () => uploadImg(),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : AssetImage('img/user.jpg') as ImageProvider,
                            child: GestureDetector(
                              onTap: uploadImg,
                              child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(CupertinoIcons.camera_fill)),
                            ),
                          ),
                        );
                      },
                    ),
        
        
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isEditing?Expanded(child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(hintText: "name"),)):Text(name ?? 'Not Set',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        isEditing?ElevatedButton(onPressed: isSaving
                            ? null
                            : () async {
                          final user = _auth.currentUser;
                          if (user == null) return;
                          final newName = nameController.text.trim();
                          if (newName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Name cannot be empty')),
                            );
                            return;
                          }
                          setState(() => isSaving = true);
                          try {
                            await _firestore.collection('users').doc(user.uid).update({
                              'name': newName,
                            });
                            if (!mounted) return;
                            setState(() {
                              name = newName;
                              isEditing = false;
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
                        }, child: isSaving ? SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2, color: Colors.white)) : Text("Save")):ElevatedButton(onPressed: (){
                          setState(() {
                            isEditing=true;
                            nameController.text = name ?? '';
                          });
                        }, child: Icon(Icons.edit,size: 20,)),
                      ],
                    ),
        
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>admin()));
                  },
                  child: Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
        
                            child: Icon(CupertinoIcons.cart_fill,size: 40,),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("My Order",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>userOrder()));
                  },
                  child: Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(

                            child: Icon(Icons.wallet,size: 40,),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("To Pay",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
        
                Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
        
                          child: Icon(Icons.fire_truck_sharp,size: 40,),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text("To Ship",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                Column(
                  children: [
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                          ),
        
                          child: Icon(Icons.shopping_bag,size: 40,),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text("Return",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
        
                          child: Icon(Icons.sms,size: 40,),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text("Review",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
        
        
        
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text('General',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
        
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,),
              child: Row(
        
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
        
                        child: Icon(Icons.currency_bitcoin,size: 30,)),
                  ),
                  SizedBox(width: 10,),
                  Text("Try Premium",style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              ),
            ),
            SizedBox(height: 10,),
        
        
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,),
              child: Row(
        
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
        
                        child: Icon(Icons.settings,size: 30,)),
                  ),
                  SizedBox(width: 10,),
                  Text("Setting",style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                _showBottomSheet(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20,),
                child: Row(

                  children: [
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,

                          child: Icon(Icons.phone_callback_rounded,size: 30,)),
                    ),
                    SizedBox(width: 10,),
                    Text("Connect Us",style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,),
              child: Row(
        
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
        
                        child: Icon(Icons.contact_page_rounded,size: 30,)),
                  ),
                  SizedBox(width: 10,),
                  Text("Term and Condition",style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              ),
            ),
            SizedBox(height: 40,),
        
            Container(
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));
                  }, child: Text("Log Out",style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Verson 1.0.0",style: appWidget.subText(18),)
                ],
              ),
            ),
        
        
          ],
        ),
      ),
    );

  }
}
