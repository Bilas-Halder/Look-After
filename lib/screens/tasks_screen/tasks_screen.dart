import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Models/task.dart';
import 'package:look_after/screens/tasks_screen/datePickerTimeline.dart';
import 'package:look_after/screens/tasks_screen/tasksAppbar.dart';

class TasksScreen extends StatelessWidget {
  static const String path='/task_screen';
  final Task task;
  TasksScreen(this.task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: CustomScrollView(
        slivers: [
          TasksAppbar(task),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePickerTimeline()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
