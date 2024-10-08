import 'dart:convert';

import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlansApi{
  String? key = dotenv.env["AIRTABLE_KEY"];
  String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['PLANS_ID']}";

  final currentUser = CurrentUser();

  Future<String> getRecordId(String id) async{
    try{
      final res = await http.get(
        Uri.parse('$baseUrl?filterByFormula={ID}="$id"'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json'
        },
      );
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        if(data['records'].isNotEmpty){
          return data['records'][0]['id'];
        }else{return '';}
      }else {return '';}
    }
    catch(e){
      return '$e';
    }
  }

  Future<Map<dynamic, dynamic>> _fetchData() async{
    try{
      final res = await http.get(
        Uri.parse('$baseUrl?filterByFormula={UserCreated}="${currentUser.username!}"'), 
        headers: {'Authorization':'Bearer $key'}
      );
      if(res.statusCode==200){
        return jsonDecode(res.body);
      }else{
        return {};
      }
    }
    catch(e){
      rethrow;
    }
  }

  Future<List<Task>> getList() async{
    try{
      Map<dynamic, dynamic> res = await _fetchData();
      List<Task> lst = [];
      var records = res["records"];
      for(var record in records){
        var field = record["fields"];
        lst.add(Task.fromJson(field));
      }
      return lst;
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> addTask(Map<String, dynamic> body) async{
    try{
      final res = await http.post(
        Uri.parse(baseUrl!),
        headers: {
          'Authorization':'Bearer $key',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body)
      );
      if(res.statusCode==200){return true;}
      else{return false;}
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> updateTask(Map<String, dynamic> body) async{
    try{
      final res = await http.put(
        Uri.parse(baseUrl!),
        headers: {
          'Authorization':'Bearer $key',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body)
      );
      if(res.statusCode==200){return true;}
      else{return false;}
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> removeTask(String taskId) async{
    try{
      String recordId = await getRecordId(taskId);
      final res = await http.delete(Uri.parse("$baseUrl/$recordId"), headers: {'Authorization':'Bearer $key'});
      return res.statusCode==200;
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> updateTaskState(Task task, String state) async{
    try{  
      String recordId = await getRecordId(task.id!);
      final body = {
         "records":[
                {
                    "id": recordId,
                    "fields":{
                        "Status": state,
                        "Title": task.title,
                        "DateCreated": task.dateCreated,
                        "Location": task.location,
                        "Content": task.content,
                        "StartTime": task.startTime,
                        "EndTime": task.endTime,
                        "Method": task.method,
                        "Host": task.host,
                        "Notes": task.note??"",
                        "UserCreated": currentUser.username,
                        "DateStart": task.dateStart
                    }
                }
            ]
      };
      bool isUpdate = await updateTask(body);
      return isUpdate;
    }
    catch(e){
      rethrow;
    }
  }
}