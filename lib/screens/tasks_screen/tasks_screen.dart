import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/boxes.dart';
import 'package:look_after/providers/SelectedDateProvider.dart';
import 'package:look_after/providers/TaskCountProvider.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/screens/tasks_screen/appbar.dart';
import 'package:look_after/screens/tasks_screen/taskCard.dart';
import 'package:look_after/screens/tasks_screen/tasksListBuilder.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants.dart';

class TasksScreen extends StatefulWidget {
  static const String path = '/task_screen';
  final TaskCategoryModel taskCategory;
  final bool fromDone, fromLeft;

  TasksScreen({this.taskCategory,this.fromDone,this.fromLeft});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime _selectedDate = DateTime.now();
  bool fromDone ,fromLeft;
  TaskCategoryModel taskCategory;

  @override
  void initState() {
    // Provider.of<TaskProvider>(context,listen: false).getTasks();
    super.initState();

    setCurrentDate();
    fromDone = widget.fromDone;
    fromLeft = widget.fromLeft;
    taskCategory = widget.taskCategory;

  }
  setCurrentDate(){
    context.read<SelectedDateProvider>().setCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<SelectedDateProvider>().setCurrentDate();


    return Scaffold(
      appBar: buildTaskScreenAppbar( taskCategory,fromDone),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingAddButton(context),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(30),
              //topRight: Radius.circular(30),
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SelectedDate(),
            fromDone || fromLeft? SizedBox() : AddDateBar(),
            SizedBox(height: 10),
            TasksListBuilder(),
            Expanded(
              child: ValueListenableBuilder<Box<TaskModel>>(
                valueListenable: Boxes.getTaskModel().listenable(),
                builder: (context, box, _){
                  final tasks= box.values.toList().cast<TaskModel>();
                  bool isEmpty = true;
                  bool allEmpty = true;
                  bool isDoneEmpty = true;
                  bool allDoneEmpty = true;
                  bool isLeftEmpty =true;
                  bool allLeftEmpty = true;

                  int leftCount=0, doneCount=0, allLeftCount=0, allDoneCount=0;

                  for(var task in tasks){
                    ///left empty condition
                    if(task.category==taskCategory.title && task.status!=0 && formatDate(DateTime.now()).compareTo(formatDate(task.date))>0){
                      isLeftEmpty = false;
                    }
                    if(task.status!=0 && formatDate(DateTime.now()).compareTo(formatDate(task.date))>0){
                      allLeftEmpty = false;
                    }

                    ///done empty condition
                    if(task.category==taskCategory.title && task.status==0){
                      isDoneEmpty = false;
                      doneCount++;
                    }
                    if(task.status==0){
                      allDoneEmpty = false;
                      allDoneCount++;
                    }

                    /// left after today condition
                    if( formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(task.date)
                        && task.category==taskCategory.title  && task.status!=0
                    ){
                      isEmpty = false;
                      leftCount++;
                    }

                    if(formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(task.date)  && task.status!=0 ){
                      allEmpty = false;
                      allLeftCount++;
                    }
                  }

                  // if(taskCategory.title.toLowerCase()=='all'){
                  //   context.watch<TasksCountProvider>().setTaskCounts(allLeftCount, allDoneCount);
                  // }
                  // else{
                  //   context.watch<TasksCountProvider>().setTaskCounts(leftCount, doneCount);
                  // }

                  if(!fromDone && !fromLeft){
                    if(isEmpty && taskCategory.title!='All'){
                      return showNoTask(context, 'No ${taskCategory.title} Tasks to do at ${formatDate(context.watch<SelectedDateProvider>().selectedDate)}.');

                    }
                    else if(allEmpty){
                      return showNoTask(context, 'No Tasks to do at ${formatDate(context.watch<SelectedDateProvider>().selectedDate)}.');
                    }
                  }
                  else if(fromDone){
                    if(isDoneEmpty && taskCategory.title!='All'){
                      return showNoTask(context, 'No Completed ${taskCategory.title} Task Yet.');
                    }
                    else if(allDoneEmpty){
                      return showNoTask(context, 'No Completed Task Yet.');
                    }
                  }
                  else{
                    if(isLeftEmpty && taskCategory.title!='All'){
                      return showNoTask(context, 'No ${taskCategory.title} Tasks Left.');
                    }
                    else if(allLeftEmpty){
                      return showNoTask(context, 'There is No Tasks Left.');
                    }
                  }

                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: tasks.length+1,
                    itemBuilder: (context,index){
                      if(index==tasks.length) return TaskCard(task: null,);

                      if(!fromDone && !fromLeft){
                        if(taskCategory.title=='All'  && tasks[index].status!=0 && formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(tasks[index].date)) return TaskCard(task: tasks[index],);

                        if(
                        formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(tasks[index].date)
                            && tasks[index].category==taskCategory.title  && tasks[index].status!=0
                        ){
                          return TaskCard(task: tasks[index],);
                        }
                      }
                      else if(fromDone){
                        if(taskCategory.title=='All' && tasks[index].status==0) return TaskCard(task: tasks[index],);

                        if(tasks[index].category==taskCategory.title  && tasks[index].status==0){
                          return TaskCard(task: tasks[index],);
                        }
                      }
                      else{
                        if(taskCategory.title=='All' && tasks[index].status!=0  && formatDate(DateTime.now()).compareTo(formatDate(tasks[index].date))>0) return TaskCard(task: tasks[index],);

                        if(tasks[index].category==taskCategory.title  && tasks[index].status!=0  && formatDate(DateTime.now()).compareTo(formatDate(tasks[index].date))>0){
                          return TaskCard(task: tasks[index],);
                        }
                      }


                      return Container();
                    },
                  );
                },
              )
            )

            // _showTasks()
          ],
        ),
      ),
    );
  }

}

Widget showNoTask (BuildContext context, String text){
  return Builder(
    builder: (BuildContext context) => Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


class AddDateBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final dateProvider = context.read<SelectedDateProvider>();

    return Container(
      margin: const EdgeInsets.only(top: 5, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 65,
        width: 50,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.teal,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        dayTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        monthTextStyle: TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.w100,
            color: Colors.grey,
            height: 0.0
        ),
        onDateChange: (date) {
          dateProvider.setNewSelectedDate(date);
        },
      ),
    );
  }
}

class SelectedDate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(formatDate(context.watch<SelectedDateProvider>().selectedDate),
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xdd484848)
              )
          ),
        ),
      ],
    );
  }
}
