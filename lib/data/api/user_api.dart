import 'dart:convert';

import 'package:daily_planner_1/data/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class UserApi{
  String? key = dotenv.env["AIRTABLE_KEY"];
  String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['USER_ID']}";

  final currentUser = CurrentUser();

  Future<Map<dynamic, dynamic>> _fetchDataUser() async{
    try{
      final res = await http.get(Uri.parse(baseUrl!), headers: {"Authorization": "Bearer $key"});
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        if(data["records"]!=null){return data;}
        else{return {};}
      }else{return {};}
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> checkUser(String email, String pass) async{
    try{
      final data = await _fetchDataUser();
      var records = data['records'];
      for(var record in records){
        var field = record['fields'];
        User user = User.fromJson(field);
        if(user.email==email&&user.pass==pass){
          currentUser.setCurrent(user);
          return true;
        }
      }
      return false;
    }
    catch(e){
      rethrow;
    }
  }
}