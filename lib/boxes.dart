import 'package:hive/hive.dart';
import 'package:look_after/Models/hive_task_model.dart';

class Boxes{
  static Box<TaskModel> getTaskModel() => Hive.box<TaskModel>('taskModels');
  static Box<TaskCategoryModel> getTaskCategoryModel() => Hive.box<TaskCategoryModel>('taskCategoryModels');
  static Box<UserModel> getUserModel() => Hive.box<UserModel>('userModel');
  static Box<IsNew> getIsNewBox() => Hive.box<IsNew>('isNew');
  static Box<EventModel> getEventModel() => Hive.box<EventModel>('eventModel');
}