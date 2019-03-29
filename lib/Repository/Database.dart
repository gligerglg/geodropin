import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/Place.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "geoDropIn.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Places(id TEXT PRIMARY KEY NOT NULL, title TEXT, latitude double, longitude double)");
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<Place>> getPlaces() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Places');
    List<Place> places = new List();
    for (int i = 0; i < list.length; i++) {
      places.add(new Place(list[i]["id"], list[i]["title"], list[i]["latitude"], list[i]["longitude"]));
    }
    return places;
  }

  Future<bool> isPlaceAlreadyExists(Place place) async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Places WHERE id='${place.id}' LIMIT 1");
    if(list.length>0)
      return Future.value(true);
    else
      return Future.value(false);
  }

  void removePlace(Place place) async{
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM Places WHERE id='${place.id}'");
  }

  void savePlace(Place place) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Places(id, title, latitude, longitude ) VALUES(' +
              '\'' +
              place.title +
              '\'' +
              ',' +
              '\'' +
              place.title +
              '\'' +
              ',' +
              '\'' +
              place.latitude.toString() +
              '\'' +
              ',' +
              '\'' +
              place.longitude.toString() +
              '\'' +
              ')');
    });
  }

}