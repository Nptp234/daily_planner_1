import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/menu_bottom_sheet.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/model/task_statistic.dart';
import 'package:daily_planner_1/model/value_statistic.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:daily_planner_1/ui/task/add_task.dart';
import 'package:daily_planner_1/ui/task/detail_task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTaskPage extends StatefulWidget{
  const ListTaskPage({super.key});

  @override
  State<ListTaskPage> createState() => _ListTaskPage();
}

class _ListTaskPage extends State<ListTaskPage>{
  
  PlansApi plansApi = PlansApi();
  final listTask = ListTask();

  Future<List<Task>> getList() async{
    try{
      List<Task> lst = await plansApi.getList();
      listTask.setTasks(lst);
      return lst;
    }
    catch(e){
      rethrow;
    }
  }

  TaskStatisticModel setTaskStatistic(Color color, double value, String title, String taskState){
    return TaskStatisticModel(color: color, value: value, title: title, taskState: taskState);
  }

  void setStatisticList(StatisticProvider provider){
    List<TaskStatisticModel> lst = [];
    setValueList(listTask.tasks);
    
    Set<String> uniqueStates = <String>{};
    for (var task in listTask.tasks) {
      uniqueStates.add(task.state!);
    }

    for(var state in uniqueStates){
      double value = calculatePercentage(state);
      lst.add(setTaskStatistic(colorState(state), value, "$value%", state));
    }
    provider.setList(lst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
      floatingActionButton: _addButton(context)
    );
  }

  Widget _addButton(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: 100,
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddTask()));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: mainColor,
                ),
                child: const Icon(Icons.add, size: 30, color: Colors.white,),
              ),
            )
          )
        ],
      )
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: SizedBox(
          height: getMainHeight(context),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    width: getMainWidth(context),
                    child: const Text("Task Statistic", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.left,),
                  ),
                  FutureBuilder(
                    future: getList(), 
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      else if(snapshot.hasError){
                        return Center(child: Text("${snapshot.error}"),);
                      }
                      else if(!snapshot.hasData){
                        return const Center(child: Text("Null data!"),);
                      }
                      else{
                        return const TaskStatistic();
                      }
                    }
                  ),
                ],
              ),
            ),
            
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: getMainWidth(context),
                      child: const Text("Tasks", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.left,),
                    ),
                  ),
                  Expanded(flex: 1, child: _listTask())
                ],
              )
            )
          ],
        ),
        )
      ),
    );
  }

  Widget _listTask(){
    return FutureBuilder<List<Task>>(
          future: getList(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasError){
              return Center(child: Text("${snapshot.error}"),);
            }
            else if(!snapshot.hasData){
              return const Center(child: Text("Null data!"),);
            }
            else{
              return Consumer<StatisticProvider>(
                builder: (BuildContext context, StatisticProvider value, Widget? child) { 
                  setStatisticList(value);
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TaskItem(task: snapshot.data![index], colorState: colorState(snapshot.data![index].state!),);
                      },
                    );
                },
              );
            }
          }
        );
  }
}

class TaskItem extends StatelessWidget{

  TaskItem({super.key, required this.task, required this.colorState});
  Task task;
  Color colorState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      // height: 70,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[100]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTaskPage(task: task)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(task.title!, style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.left,),
                // Content
                Text(task.content!, style: const TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.normal), maxLines: 2, textAlign: TextAlign.left,),
                // Date
                const SizedBox(height: 20,),
                Text("Date created: ${task.dateCreated!}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 1, textAlign: TextAlign.left,),
                // State
                const SizedBox(height: 10,),
                Text(task.state!, style: TextStyle(fontSize: 15, color: colorState, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.left,),
              ],
            ),
          ),
          IconButton(
            onPressed: (){
              customBottomSheet(context, task);
            }, 
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 20,)
          ),
        ],
      )
    );
  }

}
