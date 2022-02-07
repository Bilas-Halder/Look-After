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
        backgroundColor: Color(0xFFD2D292),
        iconColor: Color(0xFFBABA00),
        btnColor: Colors.yellow,
        left: 3,
        done: 1
      ),
      Task(
        icon: Icons.person_rounded,
        title: 'Work',
        backgroundColor: Color(0xFFBF8398),
        iconColor: Color(0xFFB7B769),
        btnColor: Colors.yellow,
        left: 3,
        done: 1
      ),
      Task(
        icon: Icons.person_rounded,
        title: 'Health',
        backgroundColor: Color(0x9598987b),
        iconColor: Color(0xFFBABA00),
        btnColor: Colors.yellow,
        left: 3,
        done: 1
      ),
      Task(isLast: true),
    ];
  }
}