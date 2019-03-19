import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geodropin/Repository/Database.dart';
import 'package:geodropin/model/GeoPoint.dart';
import 'package:geodropin/model/Place.dart';
import 'package:geodropin/ui/AddPlace/addPlace.dart';
import 'package:geodropin/ui/commom_ui/AppClipper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geodropin/util/Util.dart';
import 'package:google_maps_webservice/geocoding.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GeoPoint _myLocation;

  String _nearestLocation="";
  String _gpsStatus="";
  String _distance="";
  String _speed="";
  StreamSubscription<Position> positionStream;

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Future<List<Place>> places;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          if(position!=null){
            places.asStream().forEach((placeList) {
              for(Place place in placeList)
                print(place.title);
            });

            setState(() {
              _myLocation = new GeoPoint(position.latitude, position.longitude);
              _speed = generateSpeedData(position.speed);
              _distance = generateDistanceData(getDistance(_myLocation, new GeoPoint(position.latitude, position.longitude)));
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
              color: Theme.of(context).primaryColorDark,
              child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 130.0)),
                      new Padding(padding: EdgeInsets.only(left: 30.0)),
                      new Text(_nearestLocation.isNotEmpty?"To $_nearestLocation":"",
                        style: TextStyle(color: Colors.white,fontSize: 15),
                      ),
                      new Spacer(),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Icon(Icons.location_on,color: Colors.white,),
                          new SizedBox(width: 5,height: 5,),
                          new Text(_gpsStatus=="Active"? "Active":"Deactive",
                            style: TextStyle(color:Colors.white,fontSize: 15),
                          ),
                        ],
                      ),
                      new Padding(padding: EdgeInsets.only(right: 30.0)),
                    ],
                  ),

                  new Expanded(child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(_distance.isNotEmpty?"$_distance":"GeoDropIn",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white),),
                      new Text(_speed.isNotEmpty?"$_speed":"",textAlign: TextAlign.right,style: TextStyle(color: Colors.white,fontSize: 18),)
                    ],
                  )),

                  new Padding(padding: EdgeInsets.only(bottom: 100.0)),
                ],
              ),
            ),
          ),
          
          new Expanded(child: new FutureBuilder<List<Place>>(
            future: fetchPlacesFromDatabase(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                if(snapshot.data!=null){
                  return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,position){
                      return new ListTile(
                        title: new Text(snapshot.data[position].title),
                        leading: new CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          child: Icon(Icons.location_on,color: Colors.white,),
                        ),
                      );
                    },
                  );
                }
              }else{
                new Container(
                  alignment: Alignment.center,
                  child: new Text("NO DATA"),
                );
              }

              return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator());
            },
          ))
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: Theme.of(context).primaryColorDark,
        icon: const Icon(Icons.location_on),
        label: const Text('Add New Place'),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context){
            return new AddPlace();
          }));
//          getLocationAvailability();
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
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.help,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {},
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

  getGPSStatus(){

  }
}
