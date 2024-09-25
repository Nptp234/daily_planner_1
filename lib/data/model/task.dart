import 'dart:collection';

import 'package:intl/intl.dart';

class Task{
  String? id, title, dateCreated, dateStart, content, startTime, endTime, method, location, host, note, state;
  Task({this.id, this.dateCreated, this.content, this.startTime, this.endTime, this.method, this.host, this.note, this.state, this.title, this.location, this.dateStart});

  Task.fromJson(Map<dynamic, dynamic> e){
    id = e["ID"];
    title = e["Title"];
    dateCreated = e["DateCreated"];
    content = e["Content"];
    startTime = e["StartTime"];
    endTime = e["EndTime"];
    method = e["Method"];
    host = e["Host"];
    note = e["Notes"];
    state = e["Status"];
    location = e["Location"];
    dateStart = e["DateStart"];
  }
}

class ListTask{
  //singleton
  ListTask._privateContructor();
  static final ListTask _instance = ListTask._privateContructor();
  factory ListTask(){
    return _instance;
  }
  //

  List<Task> _tasks = [];
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  void setTasks(List<Task> lst){_tasks=lst;}
}