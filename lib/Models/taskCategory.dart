import 'package:flutter/material.dart';

class TaskCategory{
  IconData icon;
  String title;
  Color color;
  int left,done;
  bool isLast;
  TaskCategory({this.isLast,this.icon, this.title, this.color, this.left, this.done});

  static List<TaskCategory> generateTasks(){
    return[
      TaskCategory(
        icon: Icons.border_all_rounded,
        title: 'All',
        color: Colors.teal,
        left: 0,
        done: 0
      ),
      TaskCategory(
        icon: Icons.person_rounded,
        title: 'Personal',
        color: Color(0xff96032c),
        left: 0,
        done: 0
      ),
      TaskCategory(
        icon: Icons.cases_rounded,
        title: 'Work',
        color: Colors.blue,
        left: 0,
        done: 0
      ),
    ];
  }
}