import 'package:look_after/Models/tasks.dart';
import 'package:sqflite/sqflite.dart';

class dbHelper{
  static Database _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb()async{
    if(_db!=null){
      return;
    }

    try{
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version){
          print("Creating a new One");
          return db.execute(
            "Create Table $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, startTime STRING, endTime String, "
                "color INTEGER, "
                "isCompleted INTEGER, remind INTEGER, repeat STRING)",
          );
        },
      );
    }catch(e){
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    await initDb();
    return await _db?.insert(_tableName, task.toJson()??1);
  }

  static Future<List<Map<String, dynamic>>> query() async{
    print("query Functioned Called");
    return await _db.query(_tableName);
  }

  static delete(Task task) async{
    return await _db.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async{
    return await _db.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id =?
    ''', [1, id]);
  }
}