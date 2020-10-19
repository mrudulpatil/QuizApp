class Notes
{
  //String _id;

  String _time;
  String _title;
  String _desc;


  String get time => _time;

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }


  String get title => _title;

  set title(String value) {
    _title = value;
  }

  set time(String value) {
    _time = value;
  }

//Notes(this.id, this.time, this.title, this.desc);

}