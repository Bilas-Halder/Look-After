import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/screens/tasks_screen/taskCard.dart';

class TasksListBuilder extends StatelessWidget {
  final List<TaskModel> tasks = [
    TaskModel(
      email: 'bilas@gmail.com', title: 'Online Team Meeting in zoom',
      note: 'Topic is how lower the development time. Our boss will be there.',
      status: 1,
      date: DateTime.now(),
      startTime: DateFormat.jm().format(DateTime.now()).toString(),
      endTime: DateFormat.jm()
          .format(DateTime.now().add(Duration(hours: 2)))
          .toString(),
      color: Colors.teal,
      priority: 1,
      // remind:
      // repeat:
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tasks',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Text(
                      'Timeline',
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
