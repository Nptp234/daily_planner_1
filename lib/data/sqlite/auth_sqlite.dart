import 'dart:developer';

import 'package:daily_planner_1/data/sqlite/main_sqlitte.dart';

class UserSqlite{
  final _sqlite = SQLiteService();

  Future<bool> addUser(String email, String password) async{
    final db = await _sqlite.database;
    Map<String, dynamic> datas = await getUser();
    if(datas.isNotEmpty){
      await deleteUser();
    }
    var data = db.rawQuery('insert into user(email, password) values (?, ?)', [email, password]);
    log('inserted $data');
    datas = await getUser();
    return datas.isNotEmpty;
  }

  deleteUser() async{
    final db = await _sqlite.database;
    var data = db.rawQuery('delete from user');
    log('deleted $data');
  }

  updateUser(String username, String password) async{
    await deleteUser();
    await addUser(username, password);
  }

  Future<Map<String, dynamic>> getUser() async{
    final db = await _sqlite.database;
    List<Map<String, dynamic>> data = await db.rawQuery('select * from user');
    log('$data');
    if(data.isNotEmpty){return data[0];}
    else{return {};}
  }
}