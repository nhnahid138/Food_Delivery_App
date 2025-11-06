import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/getdetail.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/theme.dart';
import 'package:food/pages/widget_helper.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _confirmPasswordController=TextEditingController();
  final TextEditingController location=TextEditingController();
  bool isLoading=false;
  Future<void> signUpUser()async{
    try{
      setState(() {
        isLoading=true;
      });
    String email=_emailController.text.trim();
    String password=_passwordController.text.trim();
    String confirmPassword=_confirmPasswordController.text.trim();
    if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the fields"))
      );
      return;
    }else if(password!=confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match"))
      );
      return;
    }else{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': 'Set Name ?',
        'email': user.email,
        'photoURL': '',
        'createdAt': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>getDetail()));

    }
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
      );
    }finally{
      setState(() {
        isLoading=false;
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

              ),
              Column(
                children: [
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
                            Text("Sign Up",style: appWidget.colorboldText(24, Colors.black),),
                            SizedBox(height: 20,),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextField(
                              controller: _confirmPasswordController, // Use correct controller
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            SizedBox(height: 10,),
                            isLoading?CircularProgressIndicator():
                            ElevatedButton(
                              onPressed:signUpUser,
                              style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(5),
                                backgroundColor: MaterialStatePropertyAll(appColor),
                              ),
                              child: Text("Sign Up",style: appWidget.colorboldText(20, Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 35),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));
                      },
                      child: Text("Already Have An Account ! Log In",
                        style: appWidget.colorboldText(18, Colors.blue),),
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
}
