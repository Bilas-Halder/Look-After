import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/screens/tasks_screen/taskDetails.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../constants.dart';

class TaskCard extends StatelessWidget {
  final borderRadius = BorderRadius.only(
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );

  final TaskModel task;
  TaskCard({@required this.task});

  @override
  Widget build(BuildContext context) {

    if(task==null)return Container(height: 40,);

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildDotedTimeline(
            color: priorityColors[task.priority],
          ),
          GestureDetector(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (_) => TaskDetailDialog(task: task,)
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.65),
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 3.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Color(task.color).withOpacity(0.4),
                  borderRadius: borderRadius,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: priorityColors[task.priority],
                              shape: BoxShape.circle),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  task?.title ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Container(
                                child: Text(
                                  task?.note ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
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
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TaskPopupMenu(),
                              ProgressPopupMenu(
                                initialValue: task.status,
                                tooltip: status[task.status]['message'],
                                icon: Icon(
                                  status[task.status]['icon'],
                                  color: status[task.status]['color'],
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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

class BuildDotedTimeline extends StatelessWidget {
  final Color color;
  BuildDotedTimeline({this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 104,
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0,
        isFirst: true,
        indicatorStyle: IndicatorStyle(
          indicatorXY: 0,
          width: 15,
          indicator: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 5, color: color),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.65),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
          ),
        ),
        afterLineStyle: LineStyle(thickness: 2, color: color),
      ),
    );
  }
}

class ProgressPopupMenu extends StatelessWidget {
  final Icon icon;
  final String tooltip;
  final int initialValue;
  ProgressPopupMenu({this.icon, this.tooltip, this.initialValue});
  @override
  Widget build(BuildContext context) {
    var value = initialValue;
    return PopupMenuButton(
      tooltip: tooltip,
      initialValue: value,
      onSelected: (selectedValue) {
        onProgressionSelection(context , selectedValue);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.add_task_outlined,
                color: Colors.grey[500],
                size: 24,
              ),
              SizedBox(width: 5,),
              Text('No Progress')
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.task_alt_outlined,
                color: Colors.yellow[900],
                size: 24,
              ),
              SizedBox(width: 5,),
              Text('In Progress')
            ],
          ),
        ),
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.task_alt_outlined,
                color: Colors.green[800],
                size: 24,
              ),
              SizedBox(width: 5,),
              Text('Completed')
            ],
          ),
        ),
      ],

      padding: EdgeInsets.all(0),
      child: icon,
      iconSize: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0),),
      ),
      offset: Offset(-25, 0),
    );
  }
}

class TaskPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selectedValue) => onTaskMenuSelection(context , selectedValue),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: 1,
          child: Text('Delete'),
        ),
      ],

      padding: EdgeInsets.all(0),
      child: Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
        size: 24,
      ),
      iconSize: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft : Radius.circular(10.0),
          bottomLeft : Radius.circular(10.0),
          bottomRight : Radius.circular(10.0),
        ),
      ),
      offset: Offset(-16, 10),
    );
  }
}

void onTaskMenuSelection(BuildContext context, int value) {
  switch (value){
    case 0:
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('Edit Action will be Executed.'));
      break;
    case 1:
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('Delete Action will be Executed.'));
      break;
  }
}
void onProgressionSelection(BuildContext context, int value) {
  switch (value){
    case 0:
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('Congratulation the task is Completed.'));
      break;
    case 1:
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('Good News the task is In Progress.'));
      break;
    case 2:
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('There is No Progress for this task.'));
      break;
  }
}

SnackBar showSnackBar(String text){
  return SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}