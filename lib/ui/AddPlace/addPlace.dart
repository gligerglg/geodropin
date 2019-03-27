import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geodropin/Repository/Database.dart';
import 'package:geodropin/model/Place.dart';
import 'package:geodropin/ui/commom_ui/AlertDialog.dart';
import 'package:geodropin/ui/commom_ui/AppClipper.dart';
import 'package:geodropin/util/Util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../util/Const.dart';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  StreamSubscription<Position> positionStream;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Location _myLocation = new Location(0, 0);
  String latitude = "Latitude";
  String longitude = "Longitude";
  String place = "Pick a Place";
  Place myPlace;
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      if (position != null) {
        setState(() {
          _myLocation = new Location(position.latitude, position.longitude);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new SizedBox(
                height: 300,
              ),
              new Expanded(
                  child: Stack(
                children: <Widget>[
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      cameraPosition: CameraPosition(
                        target: new LatLng(_myLocation.lat, _myLocation.lng),
                        zoom: 9.0,
                      ),
                      compassEnabled: false,
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(20),
                    child: new Align(
                      alignment: Alignment.bottomRight,
                      child: new InkWell(
                        child: new Material(
                          elevation: 2,
                          color: Colors.deepPurple,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onTap: getPlaces,
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
          new ClipPath(
            clipper: AppClipper(),
            child: new Container(
              height: 350,
              color: Theme.of(context).primaryColorDark,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Expanded(
                          child: new Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              elevation: 2,
                              child: new Padding(
                                padding: EdgeInsets.all(10),
                                child: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Text(
                                        "$place",
                                        style: new TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    new Icon(
                                      Icons.location_on,
                                      color: Colors.deepPurple,
                                    )
                                  ],
                                ),
                              ))),
                      new SizedBox(
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  new Row(
                    children: <Widget>[
                      new SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Expanded(
                        child: new Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            elevation: 2,
                            child: new Padding(
                              padding: EdgeInsets.all(10),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Text(
                                      "$latitude",
                                      style: new TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  new Icon(
                                    Icons.gps_fixed,
                                    color: Colors.deepPurple,
                                  )
                                ],
                              ),
                            )),
                      ),
                      new SizedBox(
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  new Row(
                    children: <Widget>[
                      new SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Expanded(
                        child: new Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            elevation: 2,
                            child: new Padding(
                              padding: EdgeInsets.all(10),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Text(
                                      "$longitude",
                                      style: new TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  new Icon(
                                    Icons.gps_fixed,
                                    color: Colors.deepPurple,
                                  )
                                ],
                              ),
                            )),
                      ),
                      new SizedBox(
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: Theme.of(context).primaryColorDark,
        icon: const Icon(Icons.add),
        label: const Text('Save Location'),
        onPressed: () {
          savePlaceToDatabase(myPlace);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  getPlaces() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: API_KEY,
        mode: Mode.overlay,
        // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "lk")]);

    var places = new GoogleMapsPlaces(apiKey: API_KEY);
    PlacesDetailsResponse response =
        await places.getDetailsByPlaceId(p.placeId);

    setState(() {
      _myLocation = response.result.geometry.location;
      latitude = "Latitude : ${response.result.geometry.location.lat}";
      longitude = "Longitude : ${response.result.geometry.location.lng}";
      place = generateLocationTitle(p.description.toString());

      myPlace = Place(p.id, place, response.result.geometry.location.lat,
          response.result.geometry.location.lng);
    });

    syncCameraPosition(_myLocation);
  }

  savePlaceToDatabase(Place place) async {
    if (place != null) {
      var dbHelper = DBHelper();
      dbHelper.savePlace(place);
    }else{
      showAlertOneButton("Warning","Please select a location and save it","OK",context,(){
        Navigator.pop(context);
      });
    }
  }

  syncCameraPosition(Location location) {
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.lat, location.lng),
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );

    addMarker(location);
  }

  addMarker(Location location) {
    mapController.clearMarkers();
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          location.lat,
          location.lng,
        ),
        infoWindowText: InfoWindowText('$place', ''),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
  }
}
