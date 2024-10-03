import 'dart:developer';

import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/state/task_provider.dart';
import 'package:daily_planner_1/ui/list_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewPage extends StatefulWidget{
  CalendarViewPage({super.key, required this.taskProvider});

  TaskProvider taskProvider;

  @override
  State<CalendarViewPage> createState() => _CalendarViewPage();
}

class _CalendarViewPage extends State<CalendarViewPage>{

  late DateTime _selectedDay, _rangeStart, _rangeEnd;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDate = DateTime.now();

  late int year, month, day;
  late DateTime _firstDay, _lastDay;


  List<Task> _getTask(DateTime day){
    String formattedDate = formatDate("$day");
    log(formattedDate);
    if(widget.taskProvider.tasks.isNotEmpty){
      return widget.taskProvider.tasks.where((task)=>task.dateStart==formattedDate).toList();
    }
    else{return [];}
  }

  @override
  void initState() {
    year = _focusedDate.year;
    month = _focusedDate.month;
    day = _focusedDate.day;
    _firstDay = DateTime.utc(year, month, day);
    _lastDay = DateTime(year + 10, month, day);
    
    // Because exception error
    if(_focusedDate.isAfter(_lastDay)){
      _focusedDate=_lastDay;
    }else{_focusedDate=_firstDay;}

    _selectedDay = _focusedDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: _body(context)
        ),
      )
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _tableCalendar(),
          _listTaskForDate()
        ],
      ),
    );
  }

  Widget _tableCalendar(){
    return TableCalendar(
      focusedDay: _focusedDate, 
      firstDay: _firstDay, 
      lastDay: _lastDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDate = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if(_calendarFormat!=format){
          _calendarFormat = format;
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDate = focusedDay;
      },
      eventLoader: (day) {
        return _getTask(day);
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if(day.weekday==DateTime.sunday){
            final text = DateFormat.E().format(day);
            return Center(child: Text(text, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),);
          }
          return null;
        },
      ),
    );
  }

  Widget _listTaskForDate(){
    List<Task> taskForDate = _getTask(_selectedDay);
    return taskForDate.isNotEmpty?
    Container(
      width: getMainWidth(context),
      height: getMainHeight(context)/2.25,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: taskForDate.length,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index){
          return TaskItem(task: taskForDate[index], colorState: colorState(taskForDate[index].state!),);
        },
      ),
    ):
    const Center(child: Text("You have free time!"),);
  }

}