import 'package:flutter/material.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/taskCategory.dart';
import 'package:look_after/screens/tasks_screen/taskCard.dart';

AppBar buildTaskScreenAppbar(TaskCategoryModel taskCategory){
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Column(
      children: [
        Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Color(0xff020248),
                  borderRadius: BorderRadius.circular(12.0)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset('images/userImg.png'),
              ),
            ),
            SizedBox(width: 15,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3,),
                Hero(
                  tag: 'tasks${taskCategory.title}',
                  child: Container(
                    child: Text(
                      '${taskCategory.title} tasks!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                Text(
                  'You have ${taskCategory.left} tasks for today.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ),
              ],
            )
          ],
        ),

      ],
    ),
    actions: [
      Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
        size: 30,
      ),
      SizedBox(width: 5,)
    ],
  );
}