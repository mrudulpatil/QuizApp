import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizapp/custom_controls/page_transition.dart';
import 'package:quizapp/screens/question.dart';

class GetReady extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GetReadyState();
  }

}

class _GetReadyState extends State<GetReady>
{
  int timer = 3;
  String showtimer = "3";
  bool canceltimer = false;
  @override
  void initState() {
    // TODO: implement initState
    starttimer();
    super.initState();
  }
  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer <=1) {
          t.cancel();
          nextScreen();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        //_pointerValue=timer/10*100;
        showtimer = timer.toString();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.deepPurple[500],
      resizeToAvoidBottomInset: false,
      body: Center(
          child:
       ListView(
         shrinkWrap: true,
        children: <Widget>[
      Container(
        padding: EdgeInsets.all(20.0),
            alignment: Alignment.topCenter,
            child: Center(
              child: Text(
                "Get Ready",
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
      ),
          Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.topCenter,
            child: Center(
              child:AnimatedSwitcher(
                duration: const Duration(milliseconds:200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },

              child: Text(
                showtimer!=null?showtimer:"0",
                key: ValueKey<int>(timer),
                style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
            ),
          ),
      ],
      ),
      ),
    );
  }

  void nextScreen() {
    Navigator.pushReplacement(context,
        PageTransition(type:
        PageTransitionType.rightToLeft, child: getjson("Java")));
  }


}