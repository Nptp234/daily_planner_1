import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/bottom_bar.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/main_button.dart';
import 'package:daily_planner_1/ui/list_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  String method = "";


  DateTime now = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  DateTime selectDate = DateTime.now();

  List<String> methodValue = ["Online", "Offline"];
  String dropdownValue = "Online";

  PlansApi plansApi = PlansApi();

  Future<TimeOfDay?> _selectTime(TimeOfDay time) async{
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: time
    );
    return picked;
  }

  Future<DateTime?> _selectDay(BuildContext context, DateTime date) async{
    DateTime _last = DateTime(date.year+5, date.month, date.day);

    final DateTime? picked = await showDatePicker(
      context: context, 
      firstDate: date, 
      lastDate: _last
    );
    return picked;
  }

  bool _checkTime(TimeOfDay start, TimeOfDay end){
    if(end.hour<start.hour){return false;}
    else{
      if(end.minute<start.minute){return false;}
      else{return true;}
    }
  }

  Future<void> _handleAddTask(Task task) async{
    showAlert(context, QuickAlertType.loading, "Loading...");
    
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
                        "Method": task.endTime,
                        "Host": task.host,
                        "Notes": task.note,
                        "UserCreated": currentUser.username,
                        "DateStart": task.dateStart
                    }
                }
            ]
      };
      bool isAdd = await plansApi.addTask(task, body);
      Navigator.of(context).pop();

      if(isAdd){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomMenu()),);
      }else{
        showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
      }
    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  }

  String? _checkNullInput(BuildContext context, String value){
    if (value=="") {
      return 'Please fill out this!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Form(
          key: _formKey,
          child: _body(context)
        ),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      // height: getMainHeight(context),
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Created Date: ${formatDateTime("$now")}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
          const SizedBox(height: 20,),

          // Title
          _inputField(titleController, const TextStyle(color: Colors.grey, fontSize: 20), "Title", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),
          
          // Content
          _inputField(contentController, const TextStyle(color: Colors.grey, fontSize: 17), "Content", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),

          //Date
          _buttonPickDate(context, "Start Date"),
          const SizedBox(height: 20,),

          //Times
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buttonPickTime(context, "Start Time", startTime),
              _buttonPickTime(context, "End Time", endTime)
            ],
          ),
          const SizedBox(height: 20,),

          //Method
          _buttonMethod(context),
          const SizedBox(height: 20,),

          //Location
          _inputField(locationController, const TextStyle(color: Colors.grey, fontSize: 17), "Location", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),

          //Host
          _inputField(hostController, const TextStyle(color: Colors.grey, fontSize: 17), "Host", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),

          //Note
          _inputField(noteController, const TextStyle(color: Colors.grey, fontSize: 17), "Note", 10),
          const SizedBox(height: 20,),

          //Button
          GestureDetector(
            onTap: () {
              if(_formKey.currentState?.validate()??false){
                Task task = Task(
                  dateCreated: formatDateTime("$now"),
                  content: contentController.text,
                  startTime: startTime.format(context),
                  endTime: endTime.format(context),
                  method: dropdownValue,
                  host: hostController.text,
                  note: noteController.text,
                  title: titleController.text,
                  location: locationController.text,
                  dateStart: formatDate("$selectDate")
                );
                _handleAddTask(task);
              }
              else{
                showAlert(context, QuickAlertType.error, "Please fill all required fields!");
              }
            },
            child: ButtonCustom(text: "Add Task", currentContext: context),
          )
        ],
      ),
    ); 
  }

  Widget _buttonMethod(BuildContext context){

    return Container(
      width: getMainWidth(context),
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Text
          const Text("Choose your method: ", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10,),

          //Button
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward_rounded, size: 25, color: Colors.grey,),
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
            onChanged: (String? currentValue){
              setState(() {
                dropdownValue = currentValue!;
                method = dropdownValue;
              });
            },
            items: methodValue.map<DropdownMenuItem<String>>(
              (String value){
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value)
                );
              }
            ).toList(), 
          ),
        ],
      )
    );
  }

  Widget _buttonPickTime(BuildContext context, String title, TimeOfDay? times){
    return GestureDetector(
      onTap: () async{
        TimeOfDay? pickedTime = await _selectTime(times);
        if (pickedTime != null) {
          setState(() {
            if (title == "Start Time") {
              // Check if the picked start time is before end time
              if (_checkTime(pickedTime, endTime)) {
                startTime = pickedTime;
              } else {
                showAlert(context, QuickAlertType.error, "Start time must be before end time!");
              }
            } else if (title == "End Time") {
              // Check if the picked end time is after start time
              if (_checkTime(startTime, pickedTime)) {
                endTime = pickedTime;
              } else {
                showAlert(context, QuickAlertType.error, "End time must be after start time!");
              }
            }
          });
        }
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text("$title: ${times!.format(context)}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),)
      ),
    );
  }

  Widget _buttonPickDate(BuildContext context ,String title){
    return GestureDetector(
      onTap: () async{
        DateTime? datePick = await _selectDay(context, selectDate);
        if(datePick!=null){
          if(datePick.isBefore(DateTime.now())){
            showAlert(context, QuickAlertType.error, "Begin day can't be before now!");
          }else{
            setState(() {
              selectDate=datePick;
            });
          }
        }
      },
      child: Container(
        width: getMainWidth(context),
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text("$title: ${formatDate("$selectDate")}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),)
      ),
    );
  }

  Widget _inputField(TextEditingController input, TextStyle hintStyle, String hintText, int maxLines,{String? Function(String?)? validator}){
    return TextFormField(
      controller: input,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        fillColor: Colors.grey[100],
        errorBorder: null,
        enabledBorder: null,
        focusedBorder: null,
        disabledBorder: null,
        focusedErrorBorder: null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator,
    );
  }

}