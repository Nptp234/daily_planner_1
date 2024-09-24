import 'package:intl/intl.dart';

class Task{
  String? id, title, dateCreated, content, startTime, endTime, method, location, host, note, state;
  Task({this.id, this.dateCreated, this.content, this.startTime, this.endTime, this.method, this.host, this.note, this.state, this.title, this.location});

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
  }
}