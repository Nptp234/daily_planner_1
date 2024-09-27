import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/model/alert.dart';
import 'package:daily_planner_1/model/bottom_bar.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/ui/task/detail_task.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

PlansApi plansApi = PlansApi();

Future<void> _handleDeleteTask(BuildContext context, String taskId) async{
  try{
    showAlert(context, QuickAlertType.loading, "Please wait a few seconds!");
    bool isDeleted = await plansApi.removeTask(taskId);
    if(isDeleted){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomMenu()));
    }
    else{
      Navigator.pop(context);
      showAlert(context, QuickAlertType.error, "Error delete, please try again later!");
    }
  }
  catch(e){
    rethrow;
  }
}

customBottomSheet(BuildContext context, Task task){
  return showModalBottomSheet(
    context: context, 
    builder: (context){
      return SafeArea(
        child: Container(
          width: getMainWidth(context),
          height: getMainHeight(context)/2.5,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _customListTitle(context, Icons.edit, "Update your plan", (){Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTaskPage(task: task)));}),
              _customListTitle(context, Icons.delete, "Delete your plan", ()async{await _handleDeleteTask(context, task.id!);}),
            ],
          ),
        )
      );
    }
  );
}

Widget _customListTitle(BuildContext context, IconData icon, String title, GestureTapCallback action){
  return GestureDetector(
    onTap: action,
    child: Container(
      width: getMainWidth(context),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: Colors.black,),
          const SizedBox(width: 20,),
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    ),
  );
}