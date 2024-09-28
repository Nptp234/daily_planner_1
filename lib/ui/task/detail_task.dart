import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/model/task_form.dart';
import 'package:daily_planner_1/state/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';

class DetailTaskPage extends StatefulWidget{
  DetailTaskPage({super.key, required this.task});
  Task task;

  @override
  State<DetailTaskPage> createState() => _DetailTaskPage();
}

class _DetailTaskPage extends State<DetailTaskPage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final currentUser = CurrentUser();
  final listTask = ListTask();

  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String stateTask = "Created";
  
  
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

  Task setNewTask(){
    Task task = Task(
          id: widget.task.id,
          title: titleController.text,
          dateCreated: widget.task.dateCreated,
          location: locationController.text,
          startTime: startTime.format(context),
          endTime: endTime.format(context),
          method: dropdownValue,
          host: hostController.text,
          note: noteController.text,
          dateStart: formatDate("$selectDate"),
          content: contentController.text
    );
    return task;
  }

  Future<void> _handleUpdateTask(BuildContext context, String state) async{
    showAlert(context, QuickAlertType.loading, "Loading...");
    
    try{
      String recordId = await plansApi.getRecordId(widget.task.id!);
      final body = {
         "records":[
                {
                    "id": recordId,
                    "fields":{
                        "Title": titleController.text,
                        "DateCreated": widget.task.dateCreated,
                        "Location": locationController.text,
                        "Content": contentController.text,
                        "StartTime": startTime.format(context),
                        "EndTime": endTime.format(context),
                        "Method": dropdownValue,
                        "Host": hostController.text,
                        "Notes": noteController.text,
                        "UserCreated": currentUser.username,
                        "DateStart": formatDate("$selectDate"),
                        "Status": state
                    }
                }
            ]
      };
      bool isUpdate = await plansApi.updateTask(body);

      if(isUpdate){
        Task task = setNewTask();
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DetailTaskPage(task: task)));
        setState(() {
          widget.task = task;
        });
      }else{
        Navigator.of(context).pop();
        showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
      }
    }
    catch(e){
      Navigator.of(context).pop();
      showAlert(context, QuickAlertType.error, "An error occurred. Please try again.");
    }
  }

  @override
  void initState() {
    titleController.text = widget.task.title!;
    locationController.text = widget.task.location!;
    hostController.text = widget.task.host!;
    noteController.text = widget.task.note??"";
    contentController.text = widget.task.content!;
    selectDate = DateFormat('dd/MM/yyyy').parse(widget.task.dateStart!);
    dropdownValue = widget.task.method!;

    startTime = parseTimeOfDay(widget.task.startTime!);
    endTime = parseTimeOfDay(widget.task.endTime!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          widget.task.state!="Ended" && widget.task.state!="Done"?
          Row(
            children: [
              _buildMarkAsDoingButton(context),
              const SizedBox(width: 20,),
              _buildMarkAsDoneButton(context),
              const SizedBox(width: 20,),
            ],
          ):
          const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: _body(context)
      ),
    );
  }

  Widget _buildMarkAsDoingButton(BuildContext context,) {
    stateTask = "In Process";
    return GestureDetector(
            onTap: () => _handleUpdateTask(context, "In Process"),
            child: Text(
              "Mark as Doing",
              style: TextStyle(
                color: colorState(stateTask),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  Widget _buildMarkAsDoneButton(BuildContext context) {
    stateTask = "Done";
    return  GestureDetector(
            onTap: () => _handleUpdateTask(context, "Done"),
            child: Text(
              "Mark as Done",
              style: TextStyle(
                color: colorState(stateTask),
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
          child: TaskFormPage(
            titleController: titleController, 
            locationController: locationController, 
            hostController: hostController, 
            noteController: noteController, 
            contentController: contentController, 
            isReadOnly: widget.task.state=="Done"||widget.task.state=="Ended",
            startTime: startTime,
            endTime: endTime,
            dateStart: selectDate,
            dateCreated: DateFormat('dd/MM/yyyy HH:mm').parse(widget.task.dateCreated!),
            type: "Update Task", 
            formKey: _formKey,
            onDateSelected: _onDatePick,
            onDropdownPicked: _onDropdownPick,
            onEndTimeSelected: _onEndTimeSelected,
            onStartTimeSelected: _onStartTimeSelected,
            onTapAction: (){
              if(_formKey.currentState?.validate()??false){
                if(widget.task.state!="Done"&&widget.task.state!="Ended"){
                  _handleUpdateTask(context, "Created");
                }
              }
            }
          )
        ); 
  }

}