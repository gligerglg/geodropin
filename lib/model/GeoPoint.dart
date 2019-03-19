class GeoPoint{
  double _latitude;
  double _longitude;

  GeoPoint(this._latitude, this._longitude);

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }
}