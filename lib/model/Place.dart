class Place{
  String _id;
  String _title;
  double _latitude;
  double _longitude;


  Place(this._id,this._title, this._latitude, this._longitude);

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}