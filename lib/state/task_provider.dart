import 'package:daily_planner_1/controller/notification_logic.dart';
import 'package:daily_planner_1/controller/task_logic.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/model/value_statistic.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<Task> tasks = [];
  bool isLoading = true;
  TaskCenter taskCenter = TaskCenter();
  NotificationCenter notificationCenter = NotificationCenter();

  Future<void> fetchTasks() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      await taskCenter.getTasks();
      tasks = taskCenter.tasks;
      notificationCenter.taskProvider = this;
      notificationCenter.setTasks();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void addTask(Task task){
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task){
    tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task){
    int index = tasks.indexOf(task);
    if (index != -1) {
      tasks.removeAt(index);
      tasks[index] = task;
    }
    notifyListeners();
  }

  TaskStatisticModel setTaskStatistic(Color color, double value, String title, String taskState){
    return TaskStatisticModel(color: color, value: value, title: title, taskState: taskState);
  }

  void setStatisticList(StatisticProvider provider){
    List<TaskStatisticModel> lst = [];
    setValueList(tasks);
    
    Set<String> uniqueStates = <String>{};
    for (var task in tasks) {
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

  void reorderTasks(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    notifyListeners();
  }
}