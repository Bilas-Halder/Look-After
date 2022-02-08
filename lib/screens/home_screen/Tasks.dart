import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Models/task.dart';

class Tasks extends StatelessWidget {

  final taskList = Task.generateTasks();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15, top: 15, bottom: 15),
      child: GridView.builder(
        itemCount: taskList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => taskList[index].isLast==true ? buildAddTask():buildTask(context,taskList[index]),
      ),
    );
  }

  Widget buildAddTask(){
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(20),
      dashPattern: [10,10],
      color: Colors.grey,
      strokeWidth: 2,
      child: Center(
        child: Text(
          '+ Add',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget buildTask(BuildContext context, Task task){
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: task.backgroundColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                task.icon, color: task.iconColor,size: 35,
              ),
              Icon(
                  Icons.more_vert_outlined, color: Colors.black,size: 25,
              ),
            ],
          ),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                  color: task.btnColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text('Left ${task.left}',style: TextStyle(color: Colors.black),),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text('Done ${task.done}',style: TextStyle(color: Colors.black),),
              ),
            ],
          )
        ],
      ),

    );
  }

}

