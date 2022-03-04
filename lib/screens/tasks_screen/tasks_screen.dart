import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/taskCategory.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/boxes.dart';
import 'package:look_after/providers/SelectedDateProvider.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/screens/tasks_screen/appbar.dart';
import 'package:look_after/screens/tasks_screen/taskCard.dart';
import 'package:look_after/screens/tasks_screen/tasksListBuilder.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:get/get.dart';
import 'package:look_after/utilities/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants.dart';

class TasksScreen extends StatefulWidget {
  static const String path = '/task_screen';
  final TaskCategoryModel taskCategory;

  TasksScreen(this.taskCategory);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    Provider.of<TaskProvider>(context,listen: false).getTasks();
    context.read<SelectedDateProvider>().setCurrentDate();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<SelectedDateProvider>().setCurrentDate();

    return Scaffold(
      appBar: buildTaskScreenAppbar(widget.taskCategory),
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
            AddDateBar(),
            SizedBox(height: 10),
            TasksListBuilder(),
            Expanded(
              child: ValueListenableBuilder<Box<TaskModel>>(
                valueListenable: Boxes.getTaskModel().listenable(),
                builder: (context, box, _){
                  final tasks= box.values.toList().cast<TaskModel>();
                  bool isEmpty = true;
                  bool allEmpty = true;

                  for(var task in tasks){
                    if( formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(task.date)
                        && task.category==widget.taskCategory.title
                    ){
                      isEmpty = false;
                    }
                    if(formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(task.date) ){
                      allEmpty = false;
                    }
                  }

                  if(isEmpty && widget.taskCategory.title!='All'){
                    return showNoTask(context, widget.taskCategory.title, formatDate(context.watch<SelectedDateProvider>().selectedDate));
                  }
                  else if(allEmpty){
                    return showNoTask(context, '', formatDate(context.watch<SelectedDateProvider>().selectedDate));
                  }

                  return ListView.builder(
                    itemCount: tasks.length+1,
                    itemBuilder: (context,index){
                      if(index==tasks.length) return TaskCard(task: null,);
                      if(widget.taskCategory.title=='All' && formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(tasks[index].date)) return TaskCard(task: tasks[index],);

                      if(
                      formatDate(context.watch<SelectedDateProvider>().selectedDate)==formatDate(tasks[index].date)
                      && tasks[index].category==widget.taskCategory.title
                      ){
                        return TaskCard(task: tasks[index],);
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

Widget showNoTask (BuildContext context, String title, String date){
  return Builder(
    builder: (BuildContext context) => Expanded(
      child: Center(
        child: Text(
          'No $title task at $date.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
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
