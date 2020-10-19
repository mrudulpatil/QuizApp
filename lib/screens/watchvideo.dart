import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/custom_controls/custom_dialog.dart';
import 'package:quizapp/custom_controls/page_transition.dart';
import 'package:quizapp/model/notes.dart';
import 'package:quizapp/screens/question.dart';
import 'package:quizapp/utils/shared_pref.dart';
import 'package:quizapp/videoplayer/landscape_player_controls.dart';
import 'package:video_player/video_player.dart';

class WatchVideoScreen extends StatefulWidget {
  String langname;//,videoId;
  WatchVideoScreen(this.langname);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WatchVideoState(langname);
  }
}

class _WatchVideoState extends State<WatchVideoScreen> {
  String langname;//,videoId;
  String notesStr="";
  _WatchVideoState(this.langname);

  List<Notes> notesList;
  FlickManager flickManager;

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    MySharedPreferences.instance
        .getStringValue(langname)
        .then((value) =>
        setState(() {
          notesStr = value;
          fetchUsers();
        }));

    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network("https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/iceland_compressed.mp4?raw=true"),
          //"https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/the_valley_compressed.mp4?raw=true"),
    );

  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Widget buildListTile(List<Notes> articles, int pos) {
    //bool isFavorite = true;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: Container(
        padding: EdgeInsets.only(right: 10.0),
        decoration: new BoxDecoration(
            border: new Border(right: new BorderSide(width: 1.0, color: Colors.white))
        ),
        //child: ClipOval(

          child: Hero(
            tag: articles[pos].title,
            child: Text("Time\n"+articles[pos].time,
            style: TextStyle(color: Colors.white , fontSize: 20, fontWeight: FontWeight.bold)),
          ),
       // ),
      ),

      title: Text(
        articles[pos].title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Expanded(
          child:
          Text(articles[pos].desc, style: TextStyle(color: Colors.white, fontSize: 20))),
      // trailing: InkWell(
      //   onTap: () {
      //     setState(() {
      //       articles[pos].fav = !articles[pos].fav;
      //     });
      //   },
      //   child: articles[pos].fav
      //       ? Icon(
      //     Icons.thumb_up,
      //     color: Colors.white,
      //   )
      //       : Icon(Icons.thumb_up),
      // ),
    );
  }

  Widget buildCard(List<Notes> articles, int pos) {

    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.deepPurple[500]),
        child: buildListTile(articles, pos),
      ),

    );
  }

  Widget buildArticleList(List<Notes> articles) {

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: buildCard(articles, pos),
            onTap: () {
              showNotesDialog(articles[pos].time,articles[pos].title,articles[pos].desc);
              //navigateToArticleDetailPage(context, articles[pos].title);
              // showDialog(context: context,
              //     builder: (BuildContext context){
              //       return CustomDialogBox(
              //         title: articles[pos].title,
              //         descriptions: articles[pos].desc,
              //         text: "Close",
              //       );
              //
              //
              //     }
              // );
            },
          ),
        );
      },
    );
  }

  void navigateToArticleDetailPage(BuildContext context, String theResult) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => StudentDetailsPage(results: theResult)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Video",
        style: TextStyle(
          color: Colors.white
        ),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.arrow_right_alt_sharp,
          //   ),
          //   onPressed: () {
          //
          //
          //   },
          // )
        ],
      ),
       body:
       //VisibilityDetector(
      //   key: ObjectKey(flickManager),
      //   onVisibilityChanged: (visibility) {
      //     if (visibility.visibleFraction == 0 && this.mounted) {
      //       flickManager.flickControlManager.autoPause();
      //     } else if (visibility.visibleFraction == 1) {
      //       flickManager.flickControlManager.autoResume();
      //     }
      //   },
      //   child:
        Container(
          child: Column(
            children: <Widget>[
              FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  controls: LandscapePlayerControls(),
                ),
                systemUIOverlay: [],

                // flickVideoWithControlsFullscreen: FlickVideoWithControls(
                //   controls: FlickLandscapeControls(),
                // ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () {
                      flickManager.flickControlManager.pause();
                      var i=flickManager.flickVideoManager.videoPlayerValue.position;
                      print("pause time:"+i.toString());
                      String time=i.toString().substring(2,7);
                      addNotesDialog(time);
                    },
                    child: Text(
                      "Add Notes",
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
                  ),
                  SizedBox(width: 16),
                  OutlineButton(
                    onPressed: () {
                      MySharedPreferences.instance.setIntegerValue("marks", 0);
                      MySharedPreferences.instance.setIntegerValue("count", 0);

                      Navigator.pushReplacement(context,
                          PageTransition(type:
                          PageTransitionType.rightToLeft, child: getjson(langname)));
                    },
                    child: Text(
                      "Skip Video",
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
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 430,
                      width: 430,
                      color: Colors.white,
                      child: buildArticleList(notesList)
                    ),
                  ],
                ),
              ),
            ],
          ),
        //),
      ),
    );
  }

  void fetchUsers() {
    notesList=new List<Notes>();

    if(notesStr.isNotEmpty) {
      notesStr = notesStr.substring(0, notesStr.length - 1);
      List<String> notesArr = notesStr.split("|");
      for (int i = 0; i < notesArr.length; i++) {
        List<String> noteValues = notesArr[i].split("~");
        Notes n = new Notes();

        n.title = noteValues[0];
        n.time = noteValues[1];
        n.desc = noteValues[2];

        notesList.add(n);
      }
    }

  }

  void addNotes(String time,String title,String desc)
  {
    setState(() {
      Notes n1=new Notes();
      n1.title=title;
      n1.time=time;
      n1.desc=desc;
      notesList.add(n1);
     saveInPref(notesList);
    });
  }

  void addNotesDialog(String time)
  {
    _titleController.text="";
    _descController.text="";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time",
                      style: TextStyle(fontSize: 15)),
                    Text(time),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Title',
                          labelText:"Title" ),
                    ),
                    TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Description',
                          labelText:"Description"),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {

                          addNotes(time,_titleController.text,_descController.text);

                          Navigator.pop(context);
                          flickManager.flickControlManager.play();
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepPurple[500],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showNotesDialog(String time,String title, String desc)
  {
    _titleController.text="";
    _descController.text="";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time:",
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Text(time,
                    style: TextStyle(fontSize: 20)),
                    SizedBox(height:10),
                    Text("Title:",
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    Text(title,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height:10),
                    Text("Description:",
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    Text(desc,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                       },
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepPurple[500],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void saveInPref(List<Notes> notesList) {
    String noteStr="";
    for(int i=0;i<notesList.length;i++) {
      Notes n=notesList[i];
      noteStr =
          noteStr + n.title + "~" + n.time + "~" + n.desc +"|";
    }

    MySharedPreferences.instance.setStringValue(langname, noteStr);
  }
}
