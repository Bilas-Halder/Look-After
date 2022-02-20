import 'package:flutter/cupertino.dart';

import '../DB/db_helper.dart';
import '../Models/tasks.dart';

class TaskProvider extends ChangeNotifier{
  List<Task> taskList = [];


  Future<int> addTask({Task task}) async {
    int value  = await dbHelper.insert(task);
    taskList.add(task);
    notifyListeners();
    return value;
  }

  void getTasks() async {
    taskList.clear();
    List<Map<String, dynamic>> tasks = await dbHelper.query();
    taskList.addAll(tasks.map((e) => new Task.fromJson(e)).toList());
    notifyListeners();
  }

  void delete(Task task){
    var val = dbHelper.delete(task);
  }

  void markTaskCompleted(int id) async{
    await dbHelper.update(id);
  }
}