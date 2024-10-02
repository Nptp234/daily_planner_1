import 'package:daily_planner_1/controller/task_logic.dart';
import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/model/value_statistic.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<Task> tasks = [];
  bool isLoading = true;
  final listTask = ListTask();
  TaskCenter taskCenter = TaskCenter();

  Future<void> fetchTasks(PlansApi plansApi) async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      await taskCenter.getTasks();
      tasks = taskCenter.tasks;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
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