import 'dart:async';

import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/notification.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/state/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

class NotificationCenter{
  //singleton
  NotificationCenter._privateContructor();
  static final NotificationCenter _instance = NotificationCenter._privateContructor();
  factory NotificationCenter(){
    return _instance;
  }
  //

  late Timer timer;
  String channelId = "planner1";
  String channelName = "Planner Daily";
  List<Task> _tasks = [];
  DateTime dateNow = DateTime.now();
  PlansApi plansApi = PlansApi();
  late NotificationProvider notificationProvider;
  final listTask = ListTask();

  final tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startTime(){
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async{
      await checkTasksAndNotify();
    });
  }

  void cancelTime(){
    timer.cancel();
  }

  void setTasks(){
    _tasks = [];
    _tasks = listTask.tasks;
  }

  void addListNotifyProvider(Task task){
    String title = "You have a task incomming!";
    String description = "Task ${task.title!} will begin at ${task.startTime!}, and will end at ${task.endTime!}";
    if(!task.isNotified){notificationProvider.addList(NotificationModel(id: 0, title: title, description: description, task: task));}
  }

  TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
  

  Future<void> checkTasksAndNotify() async {
    DateFormat format = DateFormat("dd/MM/yyyy");

    for (var task in _tasks) {
      // Check if the task needs a notification
      DateTime taskDate = format.parse(task.dateStart!);
      TimeOfDay startTime = parseTimeOfDay(task.startTime!);

      int hour = DateTime.now().hour;
      if(task.startTime!.split(" ")[1].trim()=="PM"){
        hour = DateTime.now().hour-12;
      }

      DateTime now = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hour,
        DateTime.now().minute,
      );

      DateTime nowIn15Minutes = now.add(const Duration(minutes: 30));

      DateTime taskStartDateTime = DateTime(
        taskDate.year,
        taskDate.month,
        taskDate.day,
        startTime.hour,
        startTime.minute,
      );
      if (taskStartDateTime.isAfter(now) && taskStartDateTime.isBefore(nowIn15Minutes) && !task.isNotified) {
        addListNotifyProvider(task);
        task.isNotified = true;
        await showNotification("You have a task incomming!", "Task ${task.title!} will begin at ${task.startTime!}, and will end at ${task.endTime!}");
      }
    }
  }

  void checNotify(Task task){
    DateTime dateStarted = DateFormat("dd/MM/yyyy").parse(task.dateStart!);
    if(dateStarted.day==dateNow.day && dateStarted.month==dateNow.month && dateStarted.year==dateNow.year){
      showNotification("You have schedule today!", task.title!);
    }
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

  // Future<void> showNotificationDaily() async{
  //   try{
  //     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channelId, channelName, importance: Importance.high, priority: Priority.high, showWhen: true);
  //     NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0, 
  //       "You have schedule today!", 
  //       "", 
  //       _nextNotificationTime(7, 0), 
  //       notificationDetails, 
  //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  //   }
  //   catch(e){
  //     rethrow;
  //   }
  // }


}