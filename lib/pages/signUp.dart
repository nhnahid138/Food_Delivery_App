import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/widget_helper.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _confirmPasswordController=TextEditingController(); // Added controller

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
                        Colors.pink,
                        Colors.pinkAccent,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));
                    },
                    child: Text("Already Have An Account ! Log In",
                    style: appWidget.colorboldText(18, Colors.blue),),
                  ),
                ),

              ),
              Container(
                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height/5,
                  left: (screenWidth-(screenWidth/1.2))/2,
                ),
                height: MediaQuery.of(context).size.height/2,
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

                        Container(
                            alignment: Alignment.centerRight,
                            child: Text("Forgot Password?",
                              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: (){},
                          style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(5),
                            backgroundColor: MaterialStatePropertyAll(Colors.pink),
                          ),
                          child: Text("Sign Up",style: appWidget.colorboldText(20, Colors.white)),
                        ),
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
