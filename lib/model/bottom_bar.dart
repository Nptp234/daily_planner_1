
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/ui/calendar_view.dart';
import 'package:daily_planner_1/ui/list_task.dart';
import 'package:daily_planner_1/ui/notification/notification_view.dart';
import 'package:daily_planner_1/ui/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:flutter/cupertino.dart';

class BottomMenu extends StatefulWidget{
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenu();
}

class _BottomMenu extends State<BottomMenu> with TickerProviderStateMixin{
  
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3, 
      vsync: this,
    );
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
          IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const NotificationViewPage()));
            }, 
            icon: const Icon(Icons.notifications, size: 30, color: Colors.black,)
          )
        ],
      ),
      body: IndexedStack(
        index: _motionTabBarController!.index,
        children: const [
          ListTaskPage(),
          CalendarViewPage(),
          SettingViewPage(),
        ],
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