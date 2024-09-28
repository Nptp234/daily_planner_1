import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/task_statistic.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/menu_bottom_sheet.dart';
import 'package:daily_planner_1/model/notification_logic.dart';
import 'package:daily_planner_1/model/statistic_color.dart';
import 'package:daily_planner_1/model/task_statistic.dart';
import 'package:daily_planner_1/model/value_statistic.dart';
import 'package:daily_planner_1/state/reorder_provider.dart';
import 'package:daily_planner_1/state/statistic_provider.dart';
import 'package:daily_planner_1/state/task_provider.dart';
import 'package:daily_planner_1/ui/task/add_task.dart';
import 'package:daily_planner_1/ui/task/detail_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListTaskPage extends StatefulWidget{
  const ListTaskPage({super.key});

  @override
  State<ListTaskPage> createState() => _ListTaskPage();
}

class _ListTaskPage extends State<ListTaskPage> with SingleTickerProviderStateMixin {

  late TabController tabController;
  
  PlansApi plansApi = PlansApi();
  final listTask = ListTask();

  bool isLoad = false;

  int indexTab = 0;

  // Future<List<Task>> getList() async{
  //   try{
  //     List<Task> lst = await plansApi.getList();
  //     await chechForUpdateStatus(lst);
  //     listTask.setTasks(lst);
  //     return listTask.tasks;
  //   }
  //   catch(e){
  //     rethrow;
  //   }
  // }
  Future<void> getList(BuildContext context) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.fetchTasks(plansApi);
  }

  // Future<void> chechForUpdateStatus(List<Task> lst) async{
  //   try{ 
  //     for(var task in lst){
  //       if(checkForEndTime(task.endTime!, task.dateStart!)){
  //         if(task.state!="Done"){
  //           await plansApi.updateTaskState(task, "Ended");
  //         }
  //       }
  //     }
  //     NotificationCenter().setTasks();
  //   }
  //   catch(e){
  //     rethrow;
  //   }
  // }
  int refreshNumber = 9;
  Future<void> _refreshData(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    await getList(context);
    setState(() {});
  }

  // bool checkForEndTime(String endTime, String dateStart){
  //   TimeOfDay now = TimeOfDay.now();
  //   DateTime dateNow = DateTime.now();
  //   DateFormat format = DateFormat("dd/MM/yyyy");
  //   DateTime newDate = format.parse(dateStart);

  //   // String jm = endTime.split(" ")[1];
  //   List<String> times = endTime.split(" ")[0].split(":");
  //   TimeOfDay newEnd = parseTimeOfDay(endTime);
  //   if(newDate.year<=dateNow.year && newDate.month<=dateNow.month && newDate.day<dateNow.day){
  //     return true;
  //   }
  //   if(newEnd.hour<now.hour){return true;}
  //   return newEnd.hour==now.hour && newEnd.minute<now.minute;
  // }

  // TaskStatisticModel setTaskStatistic(Color color, double value, String title, String taskState){
  //   return TaskStatisticModel(color: color, value: value, title: title, taskState: taskState);
  // }

  // void setStatisticList(StatisticProvider provider){
  //   List<TaskStatisticModel> lst = [];
  //   setValueList(listTask.tasks);
    
  //   Set<String> uniqueStates = <String>{};
  //   for (var task in listTask.tasks) {
  //     uniqueStates.add(task.state!);
  //   }

  //   for(var state in uniqueStates){
  //     double value = calculatePercentage(state);
  //     lst.add(setTaskStatistic(colorState(state), value, "$value%", state));
  //   }
  //   provider.setList(lst);
  // }


  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getList(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
      floatingActionButton: _addButton(context)
    );
  }

  Widget _addButton(BuildContext context){
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask(taskProvider: value,)));
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
      },
    );
  }

  Widget _body(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: TabBar(
            controller: tabController,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            onTap: (index) {
              tabController.index = index;
            },
            tabs: const [
              Tab(text: "Task List"),
              Tab(text: "Task Statistic"),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TabBarView(
              controller: tabController,
              children: [
                _taskListTab(),
                _taskStatisticTab(),
              ]
            ),
          )
        )
      ],
    );
  }

  Widget _taskStatisticTab(){
    return SizedBox(
      width: getMainWidth(context),
      height: getMainHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getMainWidth(context),
            child: const Text("Task Statistic", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.left,),
          ),
          const TaskStatistic()
        ],
      ),
    );
  }

  Widget _taskListTab(){
    return SizedBox(
      width: getMainWidth(context),
      height: getMainHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: SizedBox(
              width: getMainWidth(context),
              child: const Text("Tasks", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.left,),
            ),
          ),
          Expanded(flex: 1, child: Consumer<StatisticProvider>(
            builder: (context, value, child) {
              return _reorderableListTask(context, value);
            },
          ))
        ],
      ),
    );
  }

  Widget _reorderableListTask(BuildContext context, StatisticProvider statistic) {
    return RefreshIndicator(
      onRefresh: (){
        return _refreshData(context);
      },
      child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              if (taskProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (taskProvider.tasks.isEmpty) {
                return const Center(child: Text("No tasks available!"));
              } else {
                return Consumer<ReorderProvider>(
                  builder: (context, value, child) {
                    value.setTasks(taskProvider.tasks);
                    taskProvider.setStatisticList(statistic);
                    return ReorderableListView.builder(
                      itemCount: taskProvider.tasks.length,
                      onReorder: value.reorderTasks,
                      itemBuilder: (context, index) {
                        Task task = taskProvider.tasks[index];
                        return TaskItem(
                          key: ValueKey(task.id),
                          task: task,
                          colorState: colorState(task.state!),
                        );
                      },
                    );
                  },
                );
              }
            },
          )
    );
  }



// Widget _reorderableListTask() {
//   return FutureBuilder<List<Task>>(
//     future: getList(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(child: Text("${snapshot.error}"));
//       } else if (!snapshot.hasData) {
//         return const Center(child: Text("Null data!"));
//       } else {
//         return Consumer<StatisticProvider>(
//           builder: (BuildContext context, StatisticProvider value, Widget? child) {
//             setStatisticList(value);
//             return RefreshIndicator(
//               onRefresh: _refreshData,
//               child: Consumer<ReorderProvider>(
//                 builder: (context, value, child) {
//                   value.setTasks(snapshot.data!);
//                   return ReorderableListView.builder(
//                     itemCount: snapshot.data!.length,
//                     scrollDirection: Axis.vertical,
//                     physics: const ScrollPhysics(),
//                     onReorder: (int oldIndex, int newIndex) {
//                       value.reorderTasks(oldIndex, newIndex);
//                     },
//                     itemBuilder: (context, index) {
//                       return TaskItem(
//                         key: ValueKey(snapshot.data![index].id),  //unique key for each item
//                         task: snapshot.data![index],
//                         colorState: colorState(snapshot.data![index].state!),
//                       );
//                     },
//                   );
//                 },
//               )
//             );
//           },
//         );
//       }
//     },
//   );
// }

  // Widget _listTask(){
  //   return RefreshIndicator(
  //     onRefresh: _refreshData,
  //     child: FutureBuilder<List<Task>>(
  //         future: getList(),
  //         builder: (context, snapshot){
  //           if(snapshot.connectionState==ConnectionState.waiting){
  //             return const Center(child: CircularProgressIndicator(),);
  //           }
  //           else if(snapshot.hasError){
  //             return Center(child: Text("${snapshot.error}"),);
  //           }
  //           else if(!snapshot.hasData){
  //             return const Center(child: Text("Null data!"),);
  //           }
  //           else{
  //             return Consumer<StatisticProvider>(
  //               builder: (BuildContext context, StatisticProvider value, Widget? child) { 
  //                 setStatisticList(value);
  //                 return ListView.builder(
  //                     itemCount: snapshot.data!.length,
  //                     scrollDirection: Axis.vertical,
  //                     physics: const ScrollPhysics(),
  //                     itemBuilder: (context, index) {
  //                       return TaskItem(task: snapshot.data![index], colorState: colorState(snapshot.data![index].state!),);
  //                     },
  //                   );
  //               },
  //             );
  //           }
  //         }
  //       )
  //   );
  // }
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
