import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/notification_logic.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskStatistic extends StatefulWidget{
  const TaskStatistic({super.key});

  @override
  State<TaskStatistic> createState() => _TaskStatistic();
}

class _TaskStatistic extends State<TaskStatistic>{

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context)/2.5,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30,),
          Expanded(child: _pieChart()),
          const SizedBox(height: 20,),
          Expanded(
            child: _pieContent(context)
          )
        ],
      ),
    );
  }

  Widget _pieContent(BuildContext context){
    return Consumer<StatisticProvider>(
      builder: (BuildContext context, StatisticProvider value, Widget? child) { 
        return ListView.builder(
              itemCount: value.getList().length,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.square_rounded, size: 25, color: value.getList()[index].color,),
                    Text(value.getList()[index].taskState, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),)
                  ],
                );
              }
            );
      },
    );
  }

  Widget _pieChart(){
    return Consumer<StatisticProvider>(
      builder: (BuildContext context, StatisticProvider value, Widget? child) { 
        return PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 50,
            sections: showingSection(value)
          )
        );
      },
    );
  }

  List<PieChartSectionData> showingSection(StatisticProvider provider,){
    return List.generate(provider.getList().length, (i){
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 30.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2, offset: Offset(0, 0))];

      Color color = provider.getList()[i].color;
      double value = provider.getList()[i].value;
      String title = provider.getList()[i].title;

      return pieSectionData(color, value, title, radius, TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows));
    });

  }

  PieChartSectionData pieSectionData(Color color, double value, String title, double radius, TextStyle textStyle){
    return PieChartSectionData(
      color: color,
      value: value,
      title: title,
      radius: radius,
      titleStyle: textStyle
    );
  }

}