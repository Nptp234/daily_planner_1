import 'package:daily_planner_1/data/model/notification.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier{

  List<NotificationModel> _lst = [];

  void addList(NotificationModel noti){
    _lst.add(noti);
    notifyListeners();
  }

  List<NotificationModel> getList()=>_lst;

}