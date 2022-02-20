import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/taskCategory.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/controllers/task_controller.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:look_after/screens/tasks_screen/datePickerTimeline.dart';
import 'package:look_after/screens/tasks_screen/tasksAppbar.dart';
import 'package:look_after/screens/tasks_screen/tasksListBuilder.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:get/get.dart';
import 'package:look_after/utilities/task_tile.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  static const String path = '/task_screen';
  final TaskCategory task;

  TasksScreen(this.task);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    Provider.of<TaskProvider>(context,listen: false).getTasks();
    setState(() {

    });
    super.initState();
  }

  getData()async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.black,
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
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(height: 10),
            _showTasks()
          ],
        ),
      ),
    );
  }

  _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/hridoy.png"),
        ),
        SizedBox(width: 10,),
      ],
    );
  }

  _showTasks() {
    return Expanded(

      child: Consumer<TaskProvider>(
        builder: (context, provider, child) {

          return ListView.builder(
              itemCount: provider.taskList.length,
              itemBuilder: (Context, index) {
                Task task = provider.taskList[index];
                print(task.toJson());
                if(task.repeat == 'Daily'){
                  DateTime date = DateFormat.jm().parse(task.startTime.toString());
                  var myTime = DateFormat("HH:mm").format(date);
                  int hour = int.parse(myTime.toString().split(":")[0]);
                  int minute = int.parse(myTime.toString().split(":")[1]);
                  NotifyHelper().scheduledNotification(task, hour, minute);
                  return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: provider.taskList.length,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    _showBottomSheet(context, provider, task);
                                  },
                                  child: TaskTile(task)
                              )
                            ],
                          ),
                        ),
                      )
                  );
                }

                if(task.date==DateFormat.yMd().format(_selectedDate)){
                  DateTime date = DateFormat.jm().parse(task.startTime.toString());
                  var myTime = DateFormat("HH:mm").format(date);
                  int hour = int.parse(myTime.toString().split(":")[0]);
                  int minute = int.parse(myTime.toString().split(":")[1]);
                  NotifyHelper().scheduledNotification(task, hour, minute);
                  return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: provider.taskList.length,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    print('clickedd');
                                    _showBottomSheet(context, provider, task);
                                  },
                                  child: TaskTile(task)
                              )
                            ],
                          ),
                        ),
                      )
                  );
                }else{
                  return Container();
                }
              }
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext, provider, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]
              ),
            ),
            Spacer(),
            task.isCompleted==1?Container():
            _bottomSheetButton(
                label: "Task Completed",
                onTap: (){
                  provider.markTaskCompleted(task.id);
                  provider.getTasks();
                  Get.back();
                },
                clr: Color(0xFF039BE5),
                context : context
            ),

            _bottomSheetButton(
              label: "Delete Task",
              onTap: (){
                provider.delete(task);
                provider.getTasks();
                Get.back();
              },
              clr: Colors.red[300],
              context : context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
                label: "Close",
                onTap: (){
                  Get.back();
                },
                clr: Colors.red[300],
                context : context,
                isClose: true
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    String label,
    Function onTap,
    Color clr,
    bool isClose=false,
    BuildContext context
  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Colors.grey[300]:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose?TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black
            ):TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat.yMMMd().format(DateTime.now()),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                      )
                  ),
                  Text(
                      "Today",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                      )
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 85,
        width: 60,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.red,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        dayTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        monthTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
}

/*
body : CustomScrollView(
        slivers: [
          TasksAppbar(task),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePickerTimeline(),
                  TasksListBuilder(),
                ],
              ),
            ),
          ),
        ],
      ),
 */

/*
body: CustomScrollView(
        slivers: [
          TasksAppbar(task),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
              ),
              child: Column(
                children: [
                  _addTaskBar(),
                  _addDateBar(),
                  //_showTasks()
                ],
              ),
            ),
          ),
        ],
      ),
 */