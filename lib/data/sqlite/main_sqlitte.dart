import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  //singleton
  static final SQLiteService _wishlistSqlite = SQLiteService._internal();
  factory SQLiteService() => _wishlistSqlite;
  SQLiteService._internal();
  //

  //
  static Database? _database;
  Future<Database> get database async {
    if (_database != null){
      return _database!;
    }

    await initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    try {
      final getDirectory = await getApplicationDocumentsDirectory();
      String path = join(getDirectory.path, 'db_planner.db');
      
      // await deleteDatabase(path);
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          log('Database opened');
        },
      );
      log('Database initialized');
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  //creates the database using  _onCreate() function
  void _onCreate(Database db, int version) async {
    try {
      await db.execute(
        'create table if not exists user (email text primary key, password text);',
      );
      log('table created: user');
      
    }
    catch (e) {
      log('Error creating tables: $e');
      rethrow;
    }
  }
  //
}