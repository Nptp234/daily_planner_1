import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/model/value_statistic.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskProvider with ChangeNotifier {
  List<Task> tasks = [];
  bool isLoading = true;
  final listTask = ListTask();

  Future<void> fetchTasks(PlansApi plansApi) async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      List<Task> fetchedTasks = await plansApi.getList();
      tasks = fetchedTasks;
      listTask.setTasks(tasks);
      await updateTaskStates(plansApi);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> updateTaskStates(PlansApi plansApi) async {
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

  TaskStatisticModel setTaskStatistic(Color color, double value, String title, String taskState){
    return TaskStatisticModel(color: color, value: value, title: title, taskState: taskState);
  }

  void setStatisticList(StatisticProvider provider){
    List<TaskStatisticModel> lst = [];
    setValueList(listTask.tasks);
    
    Set<String> uniqueStates = <String>{};
    for (var task in listTask.tasks) {
      uniqueStates.add(task.state!);
    }

    for(var state in uniqueStates){
      double value = calculatePercentage(state);
      lst.add(setTaskStatistic(colorState(state), value, "$value%", state));
    }
    provider.setList(lst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}