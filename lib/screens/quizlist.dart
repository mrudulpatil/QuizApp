import 'package:flutter/material.dart';
import 'package:quizapp/custom_controls/page_transition.dart';
import 'package:quizapp/screens/watchvideo.dart';


class QuizListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuizListState();
  }
}

class _QuizListState extends State<QuizListScreen> {
  List<String> images = [
    "assets/images/py.png",
    "assets/images/java.png",
    "assets/images/js.png",
    "assets/images/cpp.png",
    "assets/images/linux.png",
  ];

  List<String> des = [
    "Python is one of the most popular & fastest programming language since half a decade.\nIf You think you have learnt it.. \nJust test yourself !!",
    "Java has always been one of the best choices for Enterprise World. If you think you have learn the Language...\nJust Test Yourself !!",
    "Javascript is one of the most Popular programming language supporting the Web.\nIt has a wide range of Libraries making it Very Powerful !",
    "C++, being a statically typed programming language is very powerful and Fast.\nit's DMA feature makes it more useful. !",
    "Linux is a OPEN SOURCE Operating System which powers many Servers and Workstation.\nIt is also a top Priority in Development Work !",
  ];

  Widget customcard(String langname, String image, String des) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              PageTransition(type:
              PageTransitionType.rightToLeft, child: WatchVideoScreen(langname)));
        },
        child: Material(
          color: Colors.white,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      // changing from 200 to 150 as to look better
                      height: 150.0,
                      width: 150.0,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    langname,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    des,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontFamily: "Alike"),
                    maxLines: 5,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[500],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("Select Quiz",

        style: TextStyle(
        fontSize: 20.0,
        color: Colors.white)),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.arrow_right_alt_sharp),
            //   onPressed: () {
            //     // Navigator.push(
            //     //     context,
            //     //     PageTransition(
            //     //         type: PageTransitionType.rightToLeft,
            //     //         child: WatchVideoScreen(langname)));
            //   },
            // )
          ],
        ),
        body: ListView(
          children: <Widget>[

            customcard("Python", images[0], des[0]),
            customcard("Java", images[1], des[1]),
            customcard("Script", images[2], des[2]),
            customcard("C++", images[3], des[3]),
            customcard("Linux", images[4], des[4]),
          ],
        )
    );
  }
}
