import 'package:daily_planner_1/data/model/task.dart';
import 'package:flutter/material.dart';

class ReorderProvider with ChangeNotifier{
  List<Task> tasks = [];

  void setTasks(List<Task> tasks) {
    this.tasks = tasks;
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