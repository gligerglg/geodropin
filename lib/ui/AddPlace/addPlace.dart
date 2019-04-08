import 'dart:async';
import 'dart:math';

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
import '../../util/InputSet.dart';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  StreamSubscription<Position> positionStream;

  var geolocator = Geolocator();
  final Set<Marker> _markers = {};
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Location _myLocation = new Location(0, 0);
  String latitude = "Latitude";
  String longitude = "Longitude";
  String place = "Location";
  Place myPlace;
  Completer<GoogleMapController> mapController = Completer();

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
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
                height: 100,
              ),
              new Expanded(
                  child: Stack(
                children: <Widget>[
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    markers: _markers,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(7.7102243,80.9116461), zoom: 7),
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
              height: 200,
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
                                        child: new InkWell(
                                      child: new Text(
                                        "$place",
                                        style: new TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () {
                                        place=='Location'?showAlertOneButton(
                                            "GeoDropIn", "Please search a location first", "Got It!",
                                            context, (){Navigator.pop(context);}
                                        ):
                                        getUserInput(
                                            context,
                                            "Location",
                                            place == "Location"
                                                ? "Please input place title"
                                                : place,
                                            "Set Place",
                                            InputSet.INPUT_PLACE);
                                      },
                                    )),
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
                /*  new Row(
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
                                      child: new InkWell(
                                    child: new Text(
                                      "$latitude",
                                      style: new TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      //getUserInput(context, "Location", "Please input Latitude of the place", "Set Latitude",InputSet.INPUT_LAT);
                                    },
                                  )),
                                  new Icon(
                                    Icons.gps_fixed,
                                    color: Colors.grey,
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
                                      child: new InkWell(
                                    child: new Text(
                                      "$longitude",
                                      style: new TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      //getUserInput(context, "Location", "Please input Longitude of the place", "Set Longitude",InputSet.INPUT_LON);
                                    },
                                  )),
                                  new Icon(
                                    Icons.gps_fixed,
                                    color: Colors.grey,
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
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 5,
        notchMargin: 5,
        color: Theme.of(context).primaryColorDark,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        backgroundColor: Theme.of(context).primaryColorDark,
        child: new Icon(Icons.done,color: Colors.white,),
        onPressed: () {
          savePlaceToDatabase(myPlace);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onChange(String text) {}

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
      if (place.id != null) {
        Random rnd = new Random();
        place.id = rnd.nextInt(9999999).toString();
      }
      dbHelper.savePlace(place);

      showAlertOneButton(
          "Success", "New Location has successfully inserted", "OK", context,
          () {
        Navigator.pop(context);
      });
    } else {
      showAlertOneButton(
          "Warning", "Please pick a location and save it", "OK", context, () {
        Navigator.pop(context);
      });
    }
  }

  Future<void> syncCameraPosition(Location location) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
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
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: LatLng(location.lat, location.lng),
        infoWindow: InfoWindow(title: '$place', snippet: ""),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ));
    });
  }

  getUserInput(BuildContext context, String title, String content,
      String buttonText, inputSet) {
    TextEditingController controller = new TextEditingController();
    AlertDialog dialog = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      contentPadding: EdgeInsets.all(0),
      content: new Container(
        height: 200.0,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 20),
              child: new Text(
                "$title",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepPurple),
              ),
            ),
            new Expanded(
                child: new Padding(
                    padding: EdgeInsets.all(20),
                    child: new TextField(
                      decoration: InputDecoration(hintText: content),
                      keyboardType: inputSet == InputSet.INPUT_PLACE
                          ? TextInputType.text
                          : TextInputType.number,
                      controller: controller,
                    ))),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: InkWell(
                    child: new Container(
                        color: Colors.deepPurple,
                        child: new Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: new Text(
                            "$buttonText",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    onTap: () {
                      setState(() {
                        switch (inputSet) {
                          case InputSet.INPUT_PLACE:
                            if (controller.text.isNotEmpty) {
                              myPlace.title = controller.text;
                              place = controller.text;
                            }
                            break;
                          case InputSet.INPUT_LAT:
                            if (controller.text.isNotEmpty) {
                              myPlace.latitude = controller.text as double;
                              latitude = "Latitude : ${controller.text}";
                            }
                            break;
                          case InputSet.INPUT_LON:
                            if (controller.text.isNotEmpty) {
                              myPlace.longitude = controller.text as double;
                              longitude = "Longitude : ${controller.text}";
                            }
                            break;
                        }
                      });

                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    showDialog(context: context, child: dialog);
  }
}
