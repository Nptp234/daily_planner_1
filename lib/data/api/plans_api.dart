import 'dart:convert';

import 'package:daily_planner_1/data/model/task.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlansApi{
  String? key = dotenv.env["AIRTABLE_KEY"];
  String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['PLANS_ID']}";

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
        lst.add(Task.fromJson(field));
      }
      return lst;
    }
    catch(e){
      rethrow;
    }
  }
}