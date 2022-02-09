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
        icon: Icons.person_rounded,
        title: 'Personal',
        color: Colors.blue,
        left: 3,
        done: 1
      ),
      TaskCategory(
        icon: Icons.cases_rounded,
        title: 'Work',
        color: Color(0xFF109F8E),
        left: 3,
        done: 1
      ),
      TaskCategory(
        icon: Icons.favorite_rounded,
        title: 'Health',
        color: Color(0xff96032c),
        left: 3,
        done: 1
      ),
      TaskCategory(isLast: true),
    ];
  }
}