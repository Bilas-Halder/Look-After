import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:look_after/Services/notification_services.dart';

import '../boxes.dart';

part 'hive_task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject{
  @HiveField(0)
  String email;

  @HiveField(2)
  String title;

  @HiveField(3)
  String note;

  @HiveField(4)
  int status;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String startTime;

  @HiveField(7)
  String endTime;

  @HiveField(9)
  int remind;

  @HiveField(10)
  String repeat;

  @HiveField(11)
  int priority;

  @HiveField(12)
  String category;

  @HiveField(13)
  int color;

  Color givenColor;


  TaskModel({
    this.email,
    this.title,
    this.note,
    this.status,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,
    this.priority,
    this.category,
    this.color
  });
}

void addTaskModelToHiveDB(TaskModel task) {
  final box = Boxes.getTaskModel();
  box.add(task);
  print(box.keys);
  print(box.values);
  NotifyHelper().displayNotification(
      title: "An event is added from email.", body: task.note);
}


@HiveType(typeId: 1)
class TaskCategoryModel extends HiveObject{
  @HiveField(0)
  String title;

  @HiveField(1)
  int color;

  @HiveField(2)
  int icon;

  @HiveField(3)
  int left;

  @HiveField(4)
  int done;

  @HiveField(5)
  bool deleteAble;

  TaskCategoryModel({
    this.title,
    this.color,
    this.icon,
    this.left,
    this.done,
    this.deleteAble
  });


  static List<TaskCategoryModel> generateDefaultTaskCategories(){
    return[
      TaskCategoryModel(
          icon: Icons.border_all_rounded.codePoint,
          title: 'All',
          color: Colors.teal.value,
          left: 0,
          done: 0,
          deleteAble: false
      ),
      TaskCategoryModel(
          icon: Icons.person_rounded.codePoint,
          title: 'Personal',
          color: Color(0xff96032c).value,
          left: 0,
          done: 0,
          deleteAble: false
      ),
      TaskCategoryModel(
          icon: Icons.cases_rounded.codePoint,
          title: 'Work',
          color: Colors.blue.value,
          left: 0,
          done: 0,
          deleteAble: false
      ),
    ];
  }
}