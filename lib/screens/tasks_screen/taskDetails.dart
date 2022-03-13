import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/constants.dart';
import 'package:look_after/utilities/buttons.dart';

class TaskDetailDialog extends StatelessWidget {
  static const priorityTitles = ['High', 'Medium', 'Low'];

  final bool fromChat;
  final TaskModel task;
  final bool isMe;
  TaskDetailDialog({this.task,this.fromChat, this.isMe});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TaskCategoryDesign(task:task.category),
                Container(
                  padding: EdgeInsets.only(top: 20,right: 20, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 29),
                        child: Text(
                          task?.title ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      SizedBox(height: 3),
                      Container(
                        padding: EdgeInsets.only(left: 29),
                        child: Text(
                          task?.note ?? "",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${task.startTime} - ${task.endTime}",
                            style: TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${DateFormat.yMMMd().format(task.date)}",
                            style: TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      FractionallySizedBox(
                        widthFactor: 0.95,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  status[task.status]['icon'],
                                  color: status[task.status]['color'],
                                  size: 24,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${status[task.status]['message']=='Add Progress Status'? 'No Progress':status[task.status]['message']}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stars_rounded,
                                  color: priorityColors[task.priority],
                                  size: 24,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${priorityTitles[task.priority]} Priority",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                BottomDesign(task: task,fromChat: fromChat,isMe: isMe,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCategoryDesign extends StatelessWidget {
  final String task;
  TaskCategoryDesign({this.task});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 48,
        child: Stack(
          children: [
            Container(
              height: 35,
              color: Colors.teal,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child:
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                    ),
                    height: 26,
                    child: Center(
                      child: Text(
                        '${task} task.',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      );
  }
}

class BottomDesign extends StatelessWidget {
  final TaskModel task;
  final bool fromChat;
  final bool isMe;
  BottomDesign({@required this.task, this.fromChat,this.isMe});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 95,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 35,
                color: Colors.teal,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fromChat ?
                        CustomButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          color: Colors.teal,
                          title: 'Cancel',
                          width: 70,
                          reversed: true,
                        )
                            : CustomButton(
                          onPressed: (){
                            ///deleting task from hive database
                            task.delete();
                            dbHelper.deleteFromFirebase(task);
                            Navigator.pop(context);
                          },
                          color: Colors.teal,
                          title: 'Delete',
                          width: 70,
                          reversed: true,
                        ),
                        SizedBox(width: 5,),
                        fromChat ?
                        CustomButton(
                          onPressed:isMe ?(){}: ()async{
                            await dbHelper.addTaskModelToHiveDB(task);
                            Navigator.pop(context);
                          },
                          color: Colors.teal,
                          title: 'Add task',
                          width: 100,
                        )
                        : CustomButton(
                          onPressed: (){
                            task.status=0;
                            task.saveTask();
                            Navigator.pop(context);
                          },
                          color: Colors.teal,
                          title: 'Completed',
                          width: 100,
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),

          ],
        ),
      );
  }
}
