import 'dart:collection';

import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:flutter/material.dart';

class StatisticProvider with ChangeNotifier{
  List<TaskStatisticModel> _lst = [];

  void add(TaskStatisticModel task){
    _lst.add(task);
    notifyListeners();
  }

  void setList(List<TaskStatisticModel> lst){
    _lst = lst;
  }

  List<TaskStatisticModel> getList()=>_lst;
}