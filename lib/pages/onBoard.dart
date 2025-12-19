import 'package:flutter/material.dart';
import 'package:food/pages/logIn.dart';
import 'package:food/pages/signUp.dart';
import 'package:food/pages/widget_helper.dart';

import 'bottom_nevigation.dart';
import 'content_model.dart';
class onBoard extends StatefulWidget {
  const onBoard({super.key});

  @override
  State<onBoard> createState() => _onBoardState();
}

class _onBoardState extends State<onBoard> {
  int currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount:content.length,
                onPageChanged: (int index){
                  setState(() {
                    currentIndex=index;
                  });
                },
              itemBuilder: (BuildContext context, int index) {
                return Padding(padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset(content[currentIndex].image,height: MediaQuery.of(context).size.height/1.8,width: MediaQuery.of(context).size.width,fit:BoxFit.fill,),
                      SizedBox(height: 30,),
                      Text(content[currentIndex].title,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      Text(content[currentIndex].description,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                      SizedBox(height: 40,),

                    ],

                  ),
                );
              },
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(content.length, (indexDots) {
                return Container(
                  margin: EdgeInsets.only(right: 5),
                  width: currentIndex==indexDots?50:16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: currentIndex==indexDots?Colors.blue:Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(onPressed: (){
              setState(() {
                if(currentIndex==content.length-2){
                  isLastPage=true;
                }
               if(currentIndex<content.length-1){ currentIndex++;}else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>logIn()));
               }
              });
            },
                child: isLastPage? Text("Get Started",style: appWidget.colorboldText(20, Colors.white),): Text("Next",style: appWidget.colorboldText(20, Colors.white),),
            style: ButtonStyle(
                elevation: MaterialStatePropertyAll(5),
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 100,vertical: 15)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),)),
          )
        ],
      ),

      );
  }
}
