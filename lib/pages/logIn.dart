import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/adminApp/adminBottomNev.dart';
import 'package:food/pages/bottom_nevigation.dart';
import 'package:food/pages/home.dart';
import 'package:food/pages/signUp.dart';
import 'package:food/pages/theme.dart';
import 'package:food/pages/widget_helper.dart';

class logIn extends StatefulWidget {
  const logIn({super.key});

  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool isLoading=false;
  bool isAdmin=false;
  Future<void> logInUser()async{
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password"))
      );
      return;
    }

    setState(() {
      isLoading=true;
    });
    try{
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // successful login - use pushReplacement if you don't want back navigation
      isAdmin?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>adminBottomNev()))
          :Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>bottomNev()));
    } on FirebaseAuthException catch(e){
      // Log for debugging
      print('FirebaseAuthException: code=${e.code}, message=${e.message}');
      String messages=e.code;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messages)));
    } catch (e, st) {
      print('Unexpected sign-in error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An unexpected error occurred.")));
    } finally{
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
                  gradient: isAdmin?LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pink[900]!,
                      Colors.pink[800]!,
                    ],
                  ):LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.indigo,
                      Colors.indigoAccent,
                    ],
                  )

                ),
                height: MediaQuery.of(context).size.height/2.5,
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
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/3.2),
                      alignment: Alignment.center,
                        child: isAdmin?Text("Welcome Admin !",
                          style: appWidget.colorboldText(20, Colors.blue),):
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()));
                          },
                            child: Text("Don't Have An Acccount ! Sign Up",
                              style: appWidget.colorboldText(18, Colors.blue),))
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()));
                      },

                      child: Container(
                         child:  isAdmin?Text("Welcome Admin !",
                           style: appWidget.colorboldText(20, Colors.blue),):Text("Don't Have An Acccount ! Sign Up",
                            style: appWidget.colorboldText(18, Colors.blue),)
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color: Colors.white,
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 8),
                          child: Column(
                            children: [
                              Column(
                                  children: [
                                  //  Text('This section is created only',style: TextStyle(color: Colors.redAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text('Only App Showcasing purpose',style: TextStyle(color: Colors.redAccent,fontSize: 20,fontWeight: FontWeight.bold),),

                                  ],
                                ),


                              SizedBox(height: 15),
                              GestureDetector(
                                onTap: (){
                                  _emailController.text='guest@gmail.com';
                                 _passwordController.text='guest123';

                                  logInUser();
                                },
                                child: Material(
                                  color: Colors.white,
                                  elevation: 10,
                                  shadowColor: Colors.indigoAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),

                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Log In As Guest",style: appWidget.colorboldText(20, Colors.indigo[900]!),),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isAdmin=true;
                                  });
                                  _emailController.text='nhnahid138@gmail.com';
                                  _passwordController.text='mynameisnahid1';

                                  logInUser();
                                },
                                child: Material(
                                  color: Colors.white,
                                  elevation: 10,
                                  shadowColor: Colors.indigoAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),

                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Log In As Admin",style: appWidget.colorboldText(20, Colors.indigo[900]!),),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/5,
                  left: (screenWidth-(screenWidth/1.2))/2,
                ),
                height: MediaQuery.of(context).size.height/2.4,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Log In",style: appWidget.colorboldText(24, Colors.black),),
                        SizedBox(height: 20,),
                        TextField(
                          onChanged: (value){
                            if(value=='nhnahid138@gmail.com'){
                              setState(() {
                                isAdmin=true;
                              });
                            }else{
                              setState(() {
                                isAdmin=false;
                              });
                            }
                          },
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          obscureText: true, // hide password input
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),

                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()));
                              },
                              child: Text("Forgot Password?",
                                style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                            )
                        ),
                        SizedBox(height: 10,),
                        isLoading
                            ? const CircularProgressIndicator()
                            :
                        GestureDetector(
                          onTap: (){
                            logInUser();
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: AnimatedContainer(duration: Duration(seconds: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: isAdmin?Colors.pink[900]:Colors.indigo[900],
                              ),
                              alignment: Alignment.center,

                              //color: Colors.deepPurple,
                              width: isAdmin?200:90,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(isAdmin?"Log In As Admin":"Log In",style: appWidget.colorboldText(20, Colors.white)

                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
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
