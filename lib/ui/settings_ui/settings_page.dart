import 'package:flutter/material.dart';
import 'package:geodropin/ui/commom_ui/AlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUI extends StatefulWidget {
  @override
  _SettingsUIState createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  String _firstResponse = "First Response Radius : 5.0 km";
  double _firstValue = 5;
  String _secondResponse = "Second Response Radius : 500 m";
  double _secondValue = 500;

  @override
  void initState(){
    getSharedData();
    super.initState();
  }

  getSharedData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _firstValue = preferences.getDouble('first_radius') ?? 5.0;
      _secondValue =preferences.getDouble('second_radius') ?? 500.0;
      _firstResponse = "First Response Radius : $_firstValue km";
      _secondResponse = "Second Response Radius : $_secondValue m";
      print("$_firstValue \n $_secondValue");
    });

  }

  setSharedData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('first_radius', _firstValue);
    preferences.setDouble('second_radius', _secondValue);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 5,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: new Text("Settings"),
        leading: new InkWell(
          child: new Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          getTopView(),
          new Expanded(child: getBottomView()),
          new InkWell(
            child: Container(
                width: MediaQuery.of(context).size.width-20,
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child:new Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
            ),

            onTap: (){
              setSharedData();
              showAlertOneButton(
            "Success", "Settings successfully updated", "OK", context,
                () {
              Navigator.pop(context);
            });
            },
          )
        ],
      ),
    );
  }

  Widget getTopView() {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Align(
            alignment: Alignment.topLeft,
            child: new Padding(
              padding: EdgeInsets.all(10),
              child: new Text(
                "Instructions",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          new SizedBox(
            height: 10,
          ),
          getHelpItem(Icons.add_location, "Add New Location",
              "Tap on the Floating Action Button in the main menu to add a new location"),
          new SizedBox(
            height: 10,
          ),
          getHelpItem(Icons.done, "Save Location",
              "Tap on the Floating Action Button in the Location view to save selected location"),
        ],
      ),
    );
  }

  Widget getBottomView() {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Align(
            alignment: Alignment.topLeft,
            child: new Padding(
              padding: EdgeInsets.all(10),
              child: new Text(
                "Notifications",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          new SizedBox(
            height: 10,
          ),
          new Column(
            children: <Widget>[
              new Text(
                _firstResponse,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              new SizedBox(height: 10),
              new Slider(
                value: _firstValue,
                onChanged: (value) {
                  setState(() {
                    _firstResponse = "First Response Radius : $value km";
                    _firstValue = value;
                  });
                },
                divisions: 10,
                min: 0,
                max: 10,
                activeColor: Theme.of(context).primaryColorDark,
              )
            ],
          ),
          new SizedBox(
            height: 10,
          ),
          new Column(
            children: <Widget>[
              new Text(
                _secondResponse,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              new SizedBox(height: 10),
              new Slider(
                value: _secondValue,
                onChanged: (value) {
                  setState(() {
                    _secondResponse = "Second Response Radius : $value m";
                    _secondValue = value;
                  });
                },
                divisions: 10,
                min: 0,
                max: 1000,
                activeColor: Theme.of(context).primaryColorDark,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getHelpItem(icon, title, subtitle) {
    return new ListTile(
      leading: new CircleAvatar(
        child: Icon(
          icon,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      title: new Text(title),
      subtitle: new Text(
        subtitle,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
