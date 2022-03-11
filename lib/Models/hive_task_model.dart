import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:look_after/DB/db_helper.dart';
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
  @HiveField(14)
  DateTime time_stamp;

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
    this.color,
    this.time_stamp,
  });

  TaskModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    title = json['title'];
    note = json['note'];
    status = json['status'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    repeat = json['repeat'];
    priority = json['priority'];
    category = json['category'];
    color = json['color'];
    time_stamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['title'] = this.title;
    data['note'] = this.note;
    data['status'] = this.status;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    data['priority'] = this.priority;
    data['category'] = this.category;
    data['color'] = this.color;
    data['time_stamp'] = this.time_stamp;
    return data;
  }



  void saveTask(){
    this.save();
    dbHelper.updateToFirebase(this);
  }
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

@HiveType(typeId: 2)
class UserModel{

  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  String phone;
  @HiveField(3)
  String imgURL;
  @HiveField(4)
  String username;
  @HiveField(5)
  String userID;
  @HiveField(6)
  bool verified;
  @HiveField(7)
  bool edited;

  UserModel({
    this.userID,
    this.name,
    this.email,
    this.phone,
    this.imgURL,
    this.username,
    this.verified,
    this.edited,
  });

  UserModel.fromJson(Map<String, dynamic> json){
    userID = json['userID'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    imgURL = json['imgURL'];
    username = json['username'];
    verified = json['verified'];
    edited = json['edited'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['imgURL'] = this.imgURL;
    data['username'] = this.username;
    data['verified'] = this.verified;
    data['edited'] = this.edited;

    return data;
  }
}