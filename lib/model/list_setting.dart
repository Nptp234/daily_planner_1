// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:daily_planner_1/controller/auth_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsList();
}

class _SettingsList extends State<SettingsList> {

  // bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      // data: _isDark ? ThemeData.dark() : ThemeData.light(),
      data: ThemeData.light(),
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            color: Colors.white,
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                        title: "Profile",
                        icon: Icons.person,),
                    _CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    _CustomListTile(
                        title: "Security Status",
                        icon: CupertinoIcons.lock_shield),
                  ],
                ),
                _SingleSection(
                  title: "Organization",
                  children: [
                    const _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                    const _CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
                    _CustomListTile(
                        title: "Sign out", 
                        icon: Icons.exit_to_app_rounded, action: () {
                          AuthCenter().handleLogOut(context);
                        },),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function()? action;
  // ignore: unused_element
  const _CustomListTile({required this.title, required this.icon, this.trailing, this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: action,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
