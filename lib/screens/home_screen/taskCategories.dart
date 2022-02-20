import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Models/taskCategory.dart';
import 'package:look_after/screens/tasks_screen/tasks_screen.dart';

class TaskCategories extends StatelessWidget {

  final taskList = TaskCategory.generateTasks();
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
        itemBuilder: (context, index) => taskList[index].isLast==true ? buildAddTask():BuildTaskCategory(taskList[index]),
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

}



class BuildTaskCategory extends StatelessWidget {
  final TaskCategory task;
  BuildTaskCategory(this.task);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> TasksScreen(task))
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: task.color.withOpacity(0.25),///background color
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
                  task.icon,
                  color: task.color, ///Icon color
                  size: 35,
                ),
                Icon(
                  Icons.more_vert_outlined, color: Colors.black,size: 25,
                ),
              ],
            ),
            Hero(
              tag: 'tasks${task.title}',
              child: Container(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: BoxDecoration(
                        color: task.color.withOpacity(0.35),///btn color
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text('Left ${task.left}',style: TextStyle(color: Colors.black),)),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text('Done ${task.done}',style: TextStyle(color: Colors.black),)),
                  ),
                ),
              ],
            )
          ],
        ),

      ),
    );
  }
}