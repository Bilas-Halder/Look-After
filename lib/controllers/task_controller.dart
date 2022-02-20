import 'package:get/get.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/tasks.dart';
/*

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  var taskList = <Task>[].obs;
  //var taskList = <int>[1,2,3].obs;

  Future<int> addTask({Task task}) async {
    return await dbHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await dbHelper.query();
    taskList.assignAll(tasks.map((e) => new Task.fromJson(e)).toList());
  }
}*/
