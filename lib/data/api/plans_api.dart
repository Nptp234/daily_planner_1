import 'dart:convert';

import 'package:daily_planner_1/data/model/task.dart';
import 'package:daily_planner_1/data/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlansApi{
  String? key = dotenv.env["AIRTABLE_KEY"];
  String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['PLANS_ID']}";

  final currentUser = CurrentUser();

  Future<Map<dynamic, dynamic>> _fetchData() async{
    try{
      final res = await http.get(Uri.parse(baseUrl!), headers: {'Authorization':'Bearer $key'});
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
        if(field["UserCreated"]==currentUser.username){
          lst.add(Task.fromJson(field));
        }
      }
      return lst;
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> addTask(Task task) async{
    try{
      final body = {
         "records":[
                {
                    "fields":{
                        "Title": task.title,
                        "DateCreated": task.dateCreated,
                        "Location": task.location,
                        "Content": task.content,
                        "StartTime": task.startTime,
                        "EndTime": task.endTime,
                        "Method": task.endTime,
                        "Host": task.host,
                        "Notes": task.note,
                        "UserCreated": currentUser.username,
                    }
                }
            ]
      };

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
}