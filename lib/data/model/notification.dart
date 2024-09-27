import 'package:daily_planner_1/data/model/task.dart';

class NotificationModel{
  int id;
  String title, description;
  Task task;
  NotificationModel({required this.id, required this.title, required this.description, required this.task});


  // For duplicate notification 
  // Override equality operator to compare notifications by task
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotificationModel) return false;
    return task == other.task;
  }

  // Override hashCode for comparison in collections
  @override
  int get hashCode => task.hashCode;
}