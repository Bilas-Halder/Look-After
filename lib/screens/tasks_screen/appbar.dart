import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';

AppBar buildTaskScreenAppbar(TaskCategoryModel taskCategory, bool fromDone){
  UserModel user = dbHelper.getCurrentUser();

  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Column(
      children: [
        Row(
          children: [
            Hero(
              tag: 'Profile pic',
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.teal[700],
                    borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(-1.0, -1.0), //(x,y)
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: user?.imgURL != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(user?.imgURL),
                )
                    : Center(
                  child: Text(
                    user?.name != null ? user?.name[0].toUpperCase() : 'P',
                    style: TextStyle(
                        fontSize: 24
                    ),
                  ),
                ),
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

               ///TODO remove from here
               fromDone != null && !fromDone ? Text(
                  'You have 0 tasks for today.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                  ),
                ) :
               Text(
                 'You have done 0 tasks.',
                 style: TextStyle(
                     fontSize: 14,
                     color: Colors.grey
                 ),
               )
                ,
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