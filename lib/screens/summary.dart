import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/custom_controls/page_transition.dart';
import 'package:quizapp/screens/quizlist.dart';

class SummaryScreen extends StatefulWidget {
  int marks;
  SummaryScreen({Key key , @required this.marks}) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SummaryState(marks);
  }
}

class _SummaryState extends State<SummaryScreen> {

  List<String> images = [
    "assets/images/success.png",
    "assets/images/good.png",
    "assets/images/bad.png",
  ];

  String message;
  String image;

  @override
  void initState(){
    if(marks < 1){
      image = images[2];
      message = "You Should Try Hard..\n" + "You Scored $marks";
    }else if(marks < 3){
      image = images[1];
      message = "You Can Do Better..\n" + "You Scored $marks";
    }else{
      image = images[0];
      message = "You Did Very Well..\n" + "You Scored $marks";
    }
    super.initState();
  }

  int marks;
  _SummaryState(this.marks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Summary",
        style: TextStyle(
          color: Colors.white,
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(
                              image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Center(
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Quando",
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: (){
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //   builder: (context) => QuizListScreen(),
                    // ));
                    Navigator.pushReplacement(context,
                        PageTransition(type:
                        PageTransitionType.leftToRight, child: QuizListScreen()));
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.deepPurple[500]
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  borderSide: BorderSide(width: 3.0, color: Colors.deepPurple[500]),
                  splashColor: Colors.deepPurpleAccent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
