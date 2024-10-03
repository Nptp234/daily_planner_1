import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/bottom_bar.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/task_form.dart';
import 'package:daily_planner_1/state/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class AddTask extends StatefulWidget{
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTask();
}

class _AddTask extends State<AddTask>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final currentUser = CurrentUser();

  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  
  
  DateTime now = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  DateTime selectDate = DateTime.now();

  String dropdownValue = "Online";

  PlansApi plansApi = PlansApi();

  void _onStartTimeSelected(TimeOfDay time) {
    setState(() {
      startTime = time;  // Now you have access to the selected startTime
    });
  }

  void _onEndTimeSelected(TimeOfDay time) {
    setState(() {
      endTime = time;  // Now you have access to the selected endTime
    });
  }
  
  void _onDropdownPick(String value) {
    setState(() {
      dropdownValue = value;  // Now you have access to the selected endTime
    });
  }

  void _onDatePick(DateTime date) {
    setState(() {
      selectDate = date;  // Now you have access to the selected endTime
    });
  }

  Task _setTask(BuildContext context){
    return Task( 
      title: titleController.text,
      dateCreated: formatDateTime('$now'),
      location: locationController.text,
      content: contentController.text,
      startTime: startTime.format(context),
      endTime: endTime.format(context),
      method: dropdownValue,
      host: hostController.text,
      note: noteController.text,
      userCreated: currentUser.username,
      dateStart: formatDate("$selectDate"),
      state: "Created"
    );
  }

  Future<void> _handleAddTask(BuildContext context, TaskProvider value) async{
    showAlert(context, QuickAlertType.loading, "Loading...");
    Task task = _setTask(context);
    try{
      final body = {
         "records":[
                {
                    "fields":{
                        "Title": task.title,
                        "DateCreated": task.dateCreated,
                        "Location": task.location,
                        "Content": task.content,
                        "StartTime": task.startTime,
                        "EndTime": task.endTime,
                        "Method": task.method,
                        "Host": task.host,
                        "Notes": task.note,
                        "UserCreated": task.userCreated,
                        "DateStart": task.dateStart,
                        "Status": task.state
                    }
                }
            ]
      };
      bool isAdd = await plansApi.addTask(body);

      if(isAdd){
        Navigator.of(context).pop();
        value.addTask(task);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomMenu()),);
        return;
      }else{
        Navigator.of(context).pop();
        showAlert(context, QuickAlertType.error, "An error occurred when we try to create your task. Please try again.");
      }
    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: _body(context)
      ),
    );
  }

  Widget _body(BuildContext context){
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
        return Container(
          width: getMainWidth(context),
          // height: getMainHeight(context),
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: TaskFormPage(
            titleController: titleController, 
            locationController: locationController, 
            hostController: hostController, 
            noteController: noteController, 
            contentController: contentController, 
            startTime: startTime,
            endTime: endTime,
            dateStart: selectDate,
            dateCreated: now,
            type: "Add Task",

            formKey: _formKey,
            onDateSelected: _onDatePick,
            onDropdownPicked: _onDropdownPick,
            onEndTimeSelected: _onEndTimeSelected,
            onStartTimeSelected: _onStartTimeSelected,
            onTapAction: (){
              if(_formKey.currentState?.validate()??false){
                _handleAddTask(context, value);
              }
            }
          )
        ); 
      },
    );
  }
}