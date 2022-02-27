import 'package:hive/hive.dart';
import 'package:look_after/Models/hive_task_model.dart';

class Boxes{
  static Box<TaskModel> getTaskModel() => Hive.box<TaskModel>('taskModels');
  static Box<TaskCategoryModel> getTaskCategoryModel() => Hive.box<TaskCategoryModel>('taskModels');
}