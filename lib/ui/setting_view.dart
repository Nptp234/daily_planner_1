import 'package:daily_planner_1/model/list_setting.dart';
import 'package:flutter/material.dart';

class SettingViewPage extends StatefulWidget{
  const SettingViewPage({super.key});

  @override
  State<SettingViewPage> createState() => _SettingViewPage();
}

class _SettingViewPage extends State<SettingViewPage>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SettingsList(),
    );
  }

}