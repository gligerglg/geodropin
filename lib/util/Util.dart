import 'dart:math';

import '../model/GeoPoint.dart';


String generateDistanceData(double distance){
  String distance_str="";
  if(distance>=1000){
    distance_str+="${(distance/1000).toStringAsFixed(0)}km ";
    distance%=1000;
  }

  if(distance<1000)
    distance_str+="${(distance).toStringAsFixed(0)}m";

  return distance_str;
}

String generateSpeedData(double speed){
  String speed_str = "";
  //Speed *=(18/5.0);
  speed_str += "${speed.toStringAsFixed(2)} kmph";
  return speed_str;
}

double getDistance(GeoPoint point1, GeoPoint point2){
  double p = 0.017453292519943295;
  double a = 0.5 - cos((point2.latitude - point1.latitude) * p) / 2 +
      cos(point1.latitude * p) * cos(point2.latitude * p) *
          (1 - cos((point2.longitude - point1.longitude) * p)) / 2;

  return 12.742 * asin(sqrt(a)) * 1000 * 1000;
}
