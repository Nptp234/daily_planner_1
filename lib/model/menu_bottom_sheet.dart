import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:flutter/material.dart';

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
              _customListTitle(context, Icons.edit, "Update your plan", (){}),
              _customListTitle(context, Icons.delete, "Delete your plan", (){}),
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