import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationCenter{

  String channelId = "planner1";
  String channelName = "Planner Daily";
  
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  tz.TZDateTime _nextNotificationTime(int hour, int minute){
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1)); // Schedule for the next day
    }
    return scheduledDate;
  }

  Future<void> showNotification(String title, String description) async{
    try{
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channelId, channelName, importance: Importance.high, priority: Priority.high, showWhen: true);
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

  Future<void> showNotificationDaily() async{
    try{
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channelId, channelName, importance: Importance.high, priority: Priority.high, showWhen: true);
      NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, 
        "You have schedule today!", 
        "", 
        _nextNotificationTime(7, 0), 
        notificationDetails, 
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
    catch(e){
      rethrow;
    }
  }


}