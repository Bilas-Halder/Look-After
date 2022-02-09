import 'package:flutter/material.dart';
import 'package:look_after/Models/taskCategory.dart';

class TasksAppbar extends StatelessWidget {

  final TaskCategory task;
  TasksAppbar(this.task);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 90,
      backgroundColor: Colors.black,
      actions: [
        Icon(
          Icons.more_vert_rounded,
          size: 30,
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'tasksTitle',
              child: Text(
                '${task.title} tasks!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text(
              'You have ${task.left} tasks for today.',
              style: TextStyle(
                fontSize: 11,
                  color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
