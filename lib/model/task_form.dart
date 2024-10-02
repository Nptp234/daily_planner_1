import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';

class TaskFormPage extends StatefulWidget{
  TaskFormPage({
    super.key, 
    required this.titleController, 
    required this.locationController, 
    required this.hostController, 
    required this.noteController,
    required this.contentController,
    required this.startTime,
    required this.endTime,
    required this.dateStart,
    required this.dateCreated,
    required this.type,
    required this.onTapAction,
    required this.formKey,
    required this.onStartTimeSelected,
    required this.onEndTimeSelected,
    required this.onDropdownPicked,
    required this.onDateSelected,
    this.isReadOnly=false
  });
  TextEditingController titleController, locationController, hostController, noteController, contentController;
  TimeOfDay startTime, endTime;
  DateTime dateStart, dateCreated;
  String type;
  GestureTapCallback onTapAction;
  GlobalKey<FormState> formKey;
  bool? isReadOnly = false;

  static TimeOfDay getStartTime() => _TaskFormPage().startTime;
  static TimeOfDay getEndTime() => _TaskFormPage().endTime;
  static String getDropdownValue() => _TaskFormPage().dropdownValue;
  static DateTime getSelectDate() => _TaskFormPage().selectDate;

  final Function(TimeOfDay) onStartTimeSelected;
  final Function(TimeOfDay) onEndTimeSelected;
  final Function(String) onDropdownPicked;
  final Function(DateTime) onDateSelected;

  @override
  State<TaskFormPage> createState() => _TaskFormPage();
}

class _TaskFormPage extends State<TaskFormPage>{
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
    DateTime last = DateTime(date.year+5, date.month, date.day);

    final DateTime? picked = await showDatePicker(
      context: context, 
      firstDate: date, 
      lastDate: last
    );
    return picked;
  }

  void _updateStartTime(TimeOfDay pickedTime) {
    startTime = pickedTime;
    widget.onStartTimeSelected(pickedTime);  // Pass the selected startTime to the parent
  }

  void _updateEndTime(TimeOfDay pickedTime) {
    endTime = pickedTime;
    widget.onEndTimeSelected(pickedTime);  // Pass the selected endTime to the parent
  }

  void _updateDropdownValue(String value){
    dropdownValue = value;
    widget.onDropdownPicked(value);
  }

  void _updateSelectPick(DateTime date){
    selectDate = date;
    widget.onDateSelected(date);
  }

  bool _checkTime(BuildContext context, TimeOfDay start, TimeOfDay end){
    List<String> endString = end.format(context).split(" ");
    List<String> startString = start.format(context).split(" ");

    String endJm = endString[1].trim();
    String startJm = startString[1].trim();
    
    String endTime = endString[0].trim();
    String startTime = startString[0].trim();
    String endHour = endTime.split(":")[0].trim();
    String endMinute = endTime.split(":")[1].trim();
    String startHour = startTime.split(":")[0].trim();
    String startMinute = startTime.split(":")[1].trim();

    if(endJm==startJm){
      if(int.parse(endHour)<int.parse(startHour)){return false;}
      else if(int.parse(endHour)==int.parse(startHour)){
        if(int.parse(endMinute)<int.parse(startMinute)){return false;}
        else{return true;}
      }
      else{
        return true;
      }
    }else{
      return endJm=="PM";
    }
  }

  String? _checkNullInput(BuildContext context, String value){
    if (value=="") {
      return 'Please fill out this!';
    }
    return null;
  }

  @override
  void initState() {
    startTime = widget.startTime;
    endTime = widget.endTime;
    selectDate = widget.dateStart;
    now = widget.dateCreated;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: _body(context)
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Created Date: ${formatDateTime("$now")}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
          const SizedBox(height: 20,),

          // Title
          _inputField(widget.titleController, const TextStyle(color: Colors.grey, fontSize: 20), "Title", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),
          
          // Content
          _inputField(widget.contentController, const TextStyle(color: Colors.grey, fontSize: 17), "Content", 1, validator: (value)=>_checkNullInput(context, value!),),
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
          _inputField(widget.locationController, const TextStyle(color: Colors.grey, fontSize: 17), "Location", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),

          //Host
          _inputField(widget.hostController, const TextStyle(color: Colors.grey, fontSize: 17), "Host", 1, validator: (value)=>_checkNullInput(context, value!),),
          const SizedBox(height: 20,),

          //Note
          _inputField(widget.noteController, const TextStyle(color: Colors.grey, fontSize: 17), "Note", 10),
          const SizedBox(height: 20,),

          //Button
          _button(widget.type, onTap: widget.onTapAction)
        ],
      ),
    ); 
  }

  Widget _button(String title, {GestureTapCallback? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: ButtonCustom(text: title, currentContext: context),
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
            onChanged: !widget.isReadOnly!?
            (String? currentValue){
              setState(() {
                dropdownValue = currentValue!;
                method = dropdownValue;
                _updateDropdownValue(currentValue);
              });
            }:(String? currentValue){},
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
      onTap: !widget.isReadOnly!?
      () async{
        TimeOfDay? pickedTime = await _selectTime(times!);
        
        if (pickedTime != null) {
          setState(() {
            if (title == "Start Time") {
              // Check if the picked start time is before end time
              if (_checkTime(context, pickedTime, endTime)) {
                _updateStartTime(pickedTime);
                startTime = pickedTime;
              } else {
                showAlert(context, QuickAlertType.error, "Start time must be before end time!");
              }
            } else if (title == "End Time") {
              // Check if the picked end time is after start time
              if (_checkTime(context, startTime, pickedTime)) {
                _updateEndTime(pickedTime);
                endTime = pickedTime;
              } else {
                showAlert(context, QuickAlertType.error, "End time must be after start time!");
              }
            }
          });
        }
      }:(){},
      child: Container(
        width: getMainWidth(context)/2.5,
        // height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),),
            Text(times!.format(context), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
          ],
        )
      ),
    );
  }

  Widget _buttonPickDate(BuildContext context ,String title){
    return GestureDetector(
      onTap: !widget.isReadOnly!?
      () async{
        DateTime? datePick = await _selectDay(context, selectDate);
        if(datePick!=null){
          if(datePick.isBefore(DateTime.now())){
            showAlert(context, QuickAlertType.error, "Begin day can't be before now!");
          }else{
            _updateSelectPick(datePick);
            setState(() {
              selectDate=datePick;
            });
          }
        }
      }:(){},
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
      readOnly: widget.isReadOnly!,
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