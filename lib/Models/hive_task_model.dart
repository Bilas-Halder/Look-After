import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel{
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
    Color color : Colors.teal
  }){
    this.color = color.value ;
  }
}