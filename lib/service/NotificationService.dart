import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../ui/commom_ui/AlertDialog.dart';

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
    showAlertOneButton(
        "GeoDropIn Alert", "$payload", "Got It!", context, () {
      Navigator.pop(context);
    });
  }

  Future showNotificationWithDefaultSound(
      String title, String message, String payload,int notificationID) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '0001', 'geodropin', 'GeoDropIn Channel',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(notificationID, title, message, platformChannelSpecifics, payload: payload);
  }
}
