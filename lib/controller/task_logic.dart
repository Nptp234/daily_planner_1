
import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCenter{

  PlansApi plansApi = PlansApi();
  // NotificationCenter notificationCenter = NotificationCenter();

  List<Task> tasks = [];

  Future<void> getTasks() async{
    tasks = [];
    try{
      tasks = await plansApi.getList();
      // if(_task.isNotEmpty){
      //   await updateTaskStates();
      //   notificationCenter.setTasks();
      // }
    }
    catch(e){
      rethrow;
    }
  }

  
  Future<void> updateTaskStates() async {
    for (var task in tasks) {
      if (checkForEndTime(task.endTime!, task.dateStart!)) {
        if (task.state != "Done") {
          await plansApi.updateTaskState(task, "Ended");
        }
      }
    }
  }

  bool checkForEndTime(String endTime, String dateStart){
    TimeOfDay now = TimeOfDay.now();
    DateTime dateNow = DateTime.now();
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime newDate = format.parse(dateStart);

    // String jm = endTime.split(" ")[1];
    // List<String> times = endTime.split(" ")[0].split(":");
    TimeOfDay newEnd = parseTimeOfDay(endTime);
    if(newDate.year<=dateNow.year && newDate.month<=dateNow.month && newDate.day<dateNow.day){
      return true;
    }
    if(newEnd.hour<now.hour){return true;}
    return newEnd.hour==now.hour && newEnd.minute<now.minute;
  }
}