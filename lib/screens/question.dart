import 'dart:async';
import 'dart:convert';


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/custom_controls/page_transition.dart';
import 'package:quizapp/model/question_model.dart';
import 'package:quizapp/screens/get_ready.dart';

import 'package:quizapp/screens/summary.dart';
import 'package:quizapp/utils/shared_pref.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class getjson extends StatelessWidget {
  // accept the langname as a parameter

  String langname;
  getjson(this.langname);
  String assettoload;

  // a function
  // sets the asset to a particular JSON file
  // and opens the JSON
  setasset() {
    if (langname == "Python") {
      assettoload = "assets/questions/ques_one.json";
    } else if (langname == "Java") {
      assettoload = "assets/questions/ques_two.json";
    } else if (langname == "Javascript") {
      assettoload = "assets/questions/ques_one.json";
    } else if (langname == "C++") {
      assettoload = "assets/questions/ques_one.json";
    } else {
      assettoload = "assets/questions/ques_one.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    return FutureBuilder(
      future:
      DefaultAssetBundle.of(context).loadString(assettoload, cache: false),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          var jsonData=jsonDecode(snapshot.data.toString());
          List<Results> data = QuestionModel.fromJson(jsonData).results;
          return QuestionScreen(mydata: data);
        }
      },
    );
  }
}

class QuestionScreen extends StatefulWidget {
  final List<Results> mydata;

  QuestionScreen({Key key, @required this.mydata}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuestionState(mydata);
  }
}

class _QuestionState extends State<QuestionScreen> with TickerProviderStateMixin {

  final List<Results> mydata;
  _QuestionState(this.mydata);
  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0,count=0;
  bool disableAnswer = false;
  int timer = 10;
  String showtimer = "10";
  bool isNextScreenCalled=false;

  Map<int, Color> btncolor = {
    0 : Colors.white,
    1 : Colors.white,
    2 : Colors.white,
    3 : Colors.white,
  };

  bool canceltimer = false;
  double _pointerValue = 0;

  @override
  void initState() {
    starttimer();
    getCountAndMarksValue();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          if(!isNextScreenCalled) {
            nextquestion();
          }

        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        _pointerValue=timer/10*100;
        showtimer = timer.toString();
      });
    });
  }


  void nextquestion() {
    canceltimer = false;
    isNextScreenCalled=true;
    timer = 10;
    setState(() {
      if (count < 1) {
        //i = random_array[j];
        count++;
        MySharedPreferences.instance.setIntegerValue("count", count);

        Navigator.pushReplacement(context,
            PageTransition(type:
            PageTransitionType.rightToLeft, child: GetReady()//getjson("Java")
         ));
      }
      else
      {
        Navigator.pushReplacement(context,
            PageTransition(type:
            PageTransitionType.rightToLeft, child: SummaryScreen(marks: marks)));
      }
      btncolor[0] = Colors.white;
      btncolor[1] = Colors.white;
      btncolor[2] = Colors.white;
      btncolor[3] = Colors.white;
      disableAnswer = false;
    });
    starttimer();
  }

  void checkanswer(int k) {

    bool isAnswer=false;
    if (mydata[0].data.options[k].isCorrect == 1) {
      marks = marks + mydata[0].data.options[k].score;
      MySharedPreferences.instance.setIntegerValue("marks", marks);

      colortoshow = right;
      isAnswer=true;
    } else {
      colortoshow = wrong;
      isAnswer=false;
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      canceltimer = true;
      disableAnswer = true;
      if(isAnswer)
        {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.SCALE,
              headerAnimationLoop: false,
              title: 'Correct',
              desc:
              'Your answer is correct.',
              btnOkOnPress: () {},
              btnOkIcon: Icons.check,
              btnOkColor: Colors.green)
            ..show();
        }
      else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            headerAnimationLoop: false,
            title: 'Wrong',
            desc:
            'Your answer is wrong.',
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
          ..show();
      }
    });

    Timer(Duration(seconds: 3), nextquestion);
  }

  Widget choicebutton(int k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Text(
          mydata[0].data.options[k].label,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.white,
        highlightColor: Colors.white,
        minWidth:400 ,
        height: 45.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  Material MyItems(int k,String heading, int colors, BuildContext context) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
       // shadowColor: Color(0x802196F3),
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
            onTap: () => checkanswer(k),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mydata[0].data.options[k].label,
                            style: TextStyle(
                                color: new Color(colors), fontSize: 20.0),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            )));
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Quizstar",
            ),
            content: Text("You Can't Go Back At This Stage."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                 // Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                ),
              )
            ],
          ));
    },
    child: Scaffold(
      backgroundColor: Colors.deepPurple[500],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Question"),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.arrow_right_alt_sharp),
          //   onPressed: () {
          //     // Navigator.push(context,
          //     //     PageTransition(type:
          //     //     PageTransitionType.rightToLeft, child: SummaryScreen()));
          //   },
          // )
        ],
      ),
        body: ListView(
          children: <Widget>[
            Container(
             padding: EdgeInsets.all(15.0),
              width: 100,
              height: 200,
              child: SfRadialGauge(
            axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: -90,
                endAngle: 315,
                minimum: 0,
                maximum: 100,
                radiusFactor: 1,
                axisLineStyle: AxisLineStyle(
                    color: Colors.deepPurpleAccent[100],//Color.fromRGBO(106, 110, 246, 0.2),
                    thicknessUnit: GaugeSizeUnit.factor,
                    thickness: 0.05),
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 0,
                      positionFactor: 1.4,
                      widget: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              showtimer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                  fontFamily: 'Times',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                      value: _pointerValue,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      animationDuration: 1000,
                      animationType: AnimationType.ease,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Colors.white,
                      width: 0.1),
                ]),
          ],
        )
            ),
             Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.center,
                child: Text(
                  mydata[0].data.stimulus,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
               AbsorbPointer(
                absorbing: disableAnswer,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choicebutton(0),
                      choicebutton(1),
                      choicebutton(2),
                      choicebutton(3),
                    ],
                  ),
                ),
              ),
          ],
    ),
    ),
    );

  }

  void getCountAndMarksValue() {

    MySharedPreferences.instance
        .getIntegerValue("count")
        .then((value) =>
        setState(() {
          count = value;
        }));
    MySharedPreferences.instance
        .getIntegerValue("marks")
        .then((value) =>
        setState(() {
          marks = value;
        }));
  }


}



