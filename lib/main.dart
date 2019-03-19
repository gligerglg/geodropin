import 'package:flutter/material.dart';
import 'package:geodropin/ui/home_ui/Home.dart';

void main(){
  runApp(new MaterialApp(
    title: "GeoDropIn",
    home: new Home(),
    theme: ThemeData(
      primaryColorDark: Colors.deepPurple,
      primaryColorLight: Colors.deepPurpleAccent,
      disabledColor: Colors.grey,
    ),
  ));
}