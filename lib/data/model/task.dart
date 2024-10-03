import 'package:flutter/material.dart';

class Task{
  String? id, title, dateCreated, dateStart, content, startTime, endTime, method, location, host, note, state, userCreated;
  bool isNotified = false;
  Task({
    this.id, 
    this.dateCreated, 
    this.content, 
    this.startTime, 
    this.endTime, 
    this.method, 
    this.host, 
    this.note, 
    this.state, 
    this.title, 
    this.location, 
    this.dateStart, 
    this.userCreated,
    this.isNotified = false
  });

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

  // For duplicate notification 
  // Override equality operator to compare notifications by task
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Task) return false;
    return id == other.id;
  }

  // Override hashCode for comparison in collections
  @override
  int get hashCode => id.hashCode;
}

// class ListTask with ChangeNotifier{
//   //singleton
//   ListTask._privateContructor();
//   static final ListTask _instance = ListTask._privateContructor();
//   factory ListTask(){
//     return _instance;
//   }
//   //

//   List<Task> tasks = [];

//   void setTasks(List<Task> lst){
//     tasks=lst; 
//   }
// }