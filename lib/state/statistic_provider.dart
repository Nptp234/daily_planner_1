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
    _lst=[];
    _lst = lst;
    // Delay notifying listeners until after the current frame has finished building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // void notifyChange(){notifyListeners();}

  List<TaskStatisticModel> getList()=>_lst;
}