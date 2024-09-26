import 'package:daily_planner_1/model/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationViewPage extends StatefulWidget{
  const NotificationViewPage({super.key});

  @override
  State<NotificationViewPage> createState() => _NotificationViewPage();
}

class _NotificationViewPage extends State<NotificationViewPage>{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> showNotification(String title, String description) async{
    try{
      AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails("planner1", "Planner Daily", importance: Importance.high, priority: Priority.high, showWhen: true);
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
        0, 
        title, 
        description, 
        notificationDetails
      );
    }
    catch(e){
      rethrow;
    }
  }

  @override
  void initState() {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async{
            await showNotification("Testing", "Testing notification");
          },
          child: ButtonCustom(text: "Show notification", currentContext: context),
        ),
      ),
    );
  }

}