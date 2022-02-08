import 'package:flutter/material.dart';

class Task{
  IconData icon;
  String title;
  Color backgroundColor, iconColor, btnColor;
  int left,done;
  bool isLast;
  Task({this.isLast,this.icon, this.title, this.iconColor, this.backgroundColor,this.btnColor, this.left, this.done});

  static List<Task> generateTasks(){
    return[
      Task(
        icon: Icons.person_rounded,
        title: 'Personal',
        backgroundColor: Colors.blue.withOpacity(0.25),
        iconColor: Colors.blue,
        btnColor: Colors.blue.withOpacity(0.3),
        left: 3,
        done: 1
      ),
      Task(
        icon: Icons.cases_rounded,
        title: 'Work',
        backgroundColor: Color(0xFF109F8E).withOpacity(0.25),
        iconColor: Color(0xFF109F8E),  
        btnColor: Color(0xFF109F8E).withOpacity(0.4),
        left: 3,
        done: 1
      ),
      Task(
        icon: Icons.favorite_rounded,
        title: 'Health',
        backgroundColor: Color(0xff96032c).withOpacity(0.25),
        iconColor: Color(0xff96032c),
        btnColor: Color(0xff96032c).withOpacity(0.3),
        left: 3,
        done: 1
      ),
      Task(isLast: true),
    ];
  }
}