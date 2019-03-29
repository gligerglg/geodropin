import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geodropin/Repository/Database.dart';
import 'package:geodropin/model/GeoPoint.dart';
import 'package:geodropin/model/Place.dart';
import 'package:geodropin/ui/AddPlace/addPlace.dart';
import 'package:geodropin/ui/commom_ui/AppClipper.dart';
import 'package:geodropin/util/Util.dart';
import 'package:geolocator/geolocator.dart';
import '../../ui/commom_ui/AlertDialog.dart';
import '../../service/NotificationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GeoPoint _myLocation;
  NotificationService notificationService;
  String _nearestLocation = "",
      _currentLocation = "";
  String _distance = "";
  String _speed = "";
  bool _is200mDone = false,
      _is1kmDone = false;
  Place minPlace;
  double distance = 0,
      minDistance = 0;
  StreamSubscription<Position> positionStream;

  var geolocator = Geolocator();
  var locationOptions =
  LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Future<List<Place>> places;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService = new NotificationService(context);

    positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      if (position != null) {
        places.asStream().forEach((placeList) {
          minPlace = placeList[0];
          distance = 0;
          minDistance = getDistanceByLatLon(position.latitude,
              position.longitude, minPlace.latitude, minPlace.longitude);
          for (Place place in placeList) {
            distance = getDistanceByLatLon(position.latitude,
                position.longitude, place.latitude, place.longitude);
            print(distance);
            if (distance < minDistance) {
              minDistance = distance;
              minPlace = place;
            }
          }

          setState(() {
            minPlace != null
                ? _nearestLocation = generateLocationTitle(minPlace.title)
                : _nearestLocation = "";
            _myLocation = new GeoPoint(position.latitude, position.longitude);
            _speed = generateSpeedData(position.speed);
            _distance = generateDistanceData(minDistance);

            if (_currentLocation != _nearestLocation) {
              _currentLocation = _nearestLocation;
              _is200mDone = false;
              _is1kmDone = false;
              notificationService.showNotificationWithDefaultSound(
                  "GeoDropIn Alert",
                  "$_currentLocation is your nearest location. It's $_distance away from your location",
                  "Nearest location has been changed to $_currentLocation",
                  100);
            }

            if (!_is1kmDone && minDistance <= 1000 && minDistance > 200) {
              _is1kmDone = true;
              notificationService.showNotificationWithDefaultSound(
                  "GeoDropIn Alert",
                  "There is only about 1km to $_currentLocation. Please be prepare",
                  "There is only about 1km to $_currentLocation. Please be prepare",
                  200);
            } else if (!_is200mDone && minDistance <= 200) {
              _is200mDone = true;
              notificationService.showNotificationWithDefaultSound(
                  "GeoDropIn Alert",
                  "There is only about 200m to $_currentLocation. It's time!",
                  "There is only about 200m to $_currentLocation. It's time!",
                  200);
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new ClipPath(
            clipper: AppClipper(),
            child: new Container(
              height: 350,
              color: Theme
                  .of(context)
                  .primaryColorDark,
              child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 130.0)),
                      new Padding(padding: EdgeInsets.only(left: 30.0)),
                      new Text(
                        _nearestLocation.isNotEmpty
                            ? "To $_nearestLocation"
                            : "",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            _distance.isNotEmpty ? "$_distance" : "GeoDropIn",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          new Text(
                            _speed.isNotEmpty ? "$_speed" : "",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      )),
                  new Padding(padding: EdgeInsets.only(bottom: 100.0)),
                ],
              ),
            ),
          ),
          new Expanded(
              child: new FutureBuilder<List<Place>>(
                future: fetchPlacesFromDatabase(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, position) {
                          return new ListTile(
                            title: new Text(snapshot.data[position].title),
                            leading: new CircleAvatar(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColorDark,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),

                            trailing: new InkWell(
                              child: new Icon(
                                Icons.delete_outline, color: Colors.deepPurple,
                                size: 35,),
                              onTap: () {
                                showAlertTwoButtons(
                                    "Remove Place",
                                    "Are you sure to remove selected place?",
                                    "Yes",
                                    "No",
                                    context, () {
                                  var dbHelper = DBHelper();
                                  dbHelper.removePlace(snapshot.data[position]);
                                  setState(() {

                                  });
                                  Navigator.pop(context);
                                }, () {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    new Container(
                      alignment: Alignment.center,
                      child: new Text("NO DATA"),
                    );
                  }

                  return new Container(
                      alignment: AlignmentDirectional.center,
                      child: new CircularProgressIndicator());
                },
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: Theme
            .of(context)
            .primaryColorDark,
        icon: const Icon(Icons.location_on),
        label: const Text('Add New Place'),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new AddPlace();
          }));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme
                    .of(context)
                    .primaryColorDark,
              ),
              onPressed: () {
                showAlertOneButton(
                    "GeoDropIn", "Version R1.00", "Got It!", context, () {
                  Navigator.pop(context);
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.help,
                color: Theme
                    .of(context)
                    .primaryColorDark,
              ),
              onPressed: () {
                showAlertOneButton(
                    "GeoDropIn", "Reach Us \n\ngliger.glg@gmail.com", "Got It!",
                    context, () {
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<Place>> fetchPlacesFromDatabase() async {
    var dbHelper = DBHelper();
    places = dbHelper.getPlaces();
    return places;
  }

}
