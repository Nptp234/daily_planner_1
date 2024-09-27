import 'package:daily_planner_1/data/model/task.dart';

class NotificationModel{
  int id;
  String title, description;
  Task task;
  NotificationModel({required this.id, required this.title, required this.description, required this.task});
}