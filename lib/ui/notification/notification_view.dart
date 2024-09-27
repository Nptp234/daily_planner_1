import 'package:daily_planner_1/data/model/notification.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/state/notification_provider.dart';
import 'package:daily_planner_1/ui/task/detail_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationViewPage extends StatefulWidget{
  const NotificationViewPage({super.key});

  @override
  State<NotificationViewPage> createState() => _NotificationViewPage();
}

class _NotificationViewPage extends State<NotificationViewPage>{

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(context)
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      child: Consumer<NotificationProvider>(
        builder: (BuildContext context, NotificationProvider value, Widget? child) { 
          return ListView.builder(
            itemCount: value.getList().length,
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index){
              return NotificationItem(noti: value.getList()[index]);
            }
          );
        },
      )
    );
  }

}

class NotificationItem extends StatelessWidget{

  NotificationItem({super.key, required this.noti});
  NotificationModel noti;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTaskPage(task: noti.task)));
      },
      child: Container(
        width: getMainWidth(context),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[100]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title
            Text(noti.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
            const SizedBox(height: 20,),
            //description
            Text(noti.description, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15),),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  
}