import 'package:daily_planner_1/data/model/notification.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier{

  final List<NotificationModel> _lst = [];

  void addList(NotificationModel notify){
    bool exists = _lst.any((noti) => noti.task == notify.task);
    if (!exists) {
      _lst.add(notify);
      notifyListeners();
    }
  }

  List<NotificationModel> getList()=>_lst;

}