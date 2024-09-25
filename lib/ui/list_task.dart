import 'package:daily_planner_1/data/api/plans_api.dart';
import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/model/const.dart';
import 'package:daily_planner_1/model/menu_bottom_sheet.dart';
import 'package:daily_planner_1/ui/task/add_task.dart';
import 'package:flutter/material.dart';

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
      return lst;
    }
    catch(e){
      rethrow;
    }
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
        child: FutureBuilder<List<Task>>(
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
              listTask.setTasks(snapshot.data!);

              return Container(
                width: getMainWidth(context),
                height: getMainHeight(context),
                padding: const EdgeInsets.only(bottom: 20),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TaskItem(task: snapshot.data![index]);
                  },
                ),
              );
            }
          }
        )
      ),
    );
  }
}

class TaskItem extends StatelessWidget{

  TaskItem({super.key, required this.task});
  Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      // height: 70,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
            ],
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
