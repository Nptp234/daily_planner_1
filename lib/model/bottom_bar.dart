
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/controller/notification_logic.dart';
import 'package:daily_planner_1/state/notification_provider.dart';
import 'package:daily_planner_1/state/task_provider.dart';
import 'package:daily_planner_1/ui/calendar_view.dart';
import 'package:daily_planner_1/ui/list_task.dart';
import 'package:daily_planner_1/ui/notification/notification_view.dart';
import 'package:daily_planner_1/ui/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatefulWidget{
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenu();
}

class _BottomMenu extends State<BottomMenu> with TickerProviderStateMixin{
  
  MotionTabBarController? _motionTabBarController;
  final notificationCenter = NotificationCenter();

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3, 
      vsync: this,
    );
    notificationCenter.startTime();
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Consumer<NotificationProvider>(
            builder: (BuildContext context, NotificationProvider value, Widget? child) { 
              notificationCenter.notificationProvider = value;
              return SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationViewPage()));
                      }, 
                      icon: const Icon(Icons.notifications, size: 30, color: Colors.black,)
                    ),
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: Text("${value.getList().length}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),)
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, value, child) {
          notificationCenter.taskProvider = value;
          return IndexedStack(
            index: _motionTabBarController!.index,
            children: [
              const ListTaskPage(),
              CalendarViewPage(taskProvider: value,),
              const SettingViewPage(),
            ],
          );
        },
      ),

      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        tabIconSize: 28.0,
        tabIconSelectedSize: 30.0,
        tabIconColor: Colors.grey,
        tabSelectedColor: mainColor,
        tabIconSelectedColor: Colors.white,
        tabSize: 50,
        tabBarHeight: 60,
        tabBarColor: Colors.white,
        textStyle: const TextStyle(color: Colors.transparent),

        initialSelectedTab: "List Task", 
        labels: const ["List Task", "Calendar", "Setting"],
        icons: const [Icons.list, CupertinoIcons.calendar, Icons.settings],

        onTabItemSelected: (int value) {
            setState(() {
              _motionTabBarController!.index = value;
            });
          },
      ),
    );
  }

}