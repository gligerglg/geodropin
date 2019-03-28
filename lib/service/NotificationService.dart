import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  NotificationService(this.context) {
    _InitializeNotifications();
  }

  _InitializeNotifications() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: const Text("GeoDropIn Alert"),
              content: new Text("$payload"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: new Text(
                      "Got It!",
                      style: TextStyle(color: Colors.deepPurple),
                    ))
              ],
            ));
  }

  Future showNotificationWithDefaultSound(
      String title, String message, String payload) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '0001', 'geodropin', 'GeoDropIn Channel',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, message, platformChannelSpecifics, payload: payload);
  }
}
