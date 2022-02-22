import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/taskCategory.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/controllers/task_controller.dart';
import 'package:look_after/providers/SelectedDateProvider.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:look_after/screens/tasks_screen/appbar.dart';
import 'package:look_after/screens/tasks_screen/datePickerTimeline.dart';
import 'package:look_after/screens/tasks_screen/taskCard.dart';
import 'package:look_after/screens/tasks_screen/tasksAppbar.dart';
import 'package:look_after/screens/tasks_screen/tasksListBuilder.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:get/get.dart';
import 'package:look_after/utilities/task_tile.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  static const String path = '/task_screen';
  final TaskCategory taskCategory;

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

    final List <TaskModel> tasks=[
      TaskModel(
      id: 1, title: 'Online Team Meeting in zoom.',
      note: 'Topic is how lower the development time. Our boss will be there.',
      status: 0,
      date: DateTime.now(),
      startTime: DateFormat.jm().format(DateTime.now()).toString(),
      endTime: DateFormat.jm().format(DateTime.now().add(Duration(hours:2))).toString(),
      color: Colors.teal,
      priority: 0,
      category: 'Personal',
      // remind:
      // repeat:
    ),
      TaskModel(
      id: 1, title: 'Online Class of ShafkatSir',
      note: 'Topic is how lower the development time. Our boss will be there.',
      status: 2,
      date: DateTime.now(),
      startTime: DateFormat.jm().format(DateTime.now()).toString(),
      endTime: DateFormat.jm().format(DateTime.now().add(Duration(hours:2))).toString(),
      color: Colors.white,
      priority: 1,
      // remind:
      // repeat:
        category: 'Personal',
    ),
      TaskModel(
      id: 1, title: 'Online Team Meeting in Google Meet',
      note: 'Business Meeting.',
      status: 1,
      date: DateTime.now(),
      startTime: DateFormat.jm().format(DateTime.now()).toString(),
      endTime: DateFormat.jm().format(DateTime.now().add(Duration(hours:2))).toString(),
      color: Colors.cyan,
      priority: 2,
      // remind:
      // repeat:
        category: 'Personal',
    ),
      TaskModel(
      id: 1, title: 'Zoom Meeting',
      note: 'Topic is how lower the development time. Our boss will be there.',
      status: 2,
      date: DateTime.now(),
      startTime: DateFormat.jm().format(DateTime.now()).toString(),
      endTime: DateFormat.jm().format(DateTime.now().add(Duration(hours:2))).toString(),
      color: Colors.redAccent,
      priority: 1,
      // remind:
      // repeat:
        category: 'Personal',
    ),
      TaskModel(
        id: 1, title: 'Online Team Meeting in zoom.',
        note: 'Topic is how lower the development time. Our boss will be there.',
        status: 0,
        date: DateTime.now(),
        startTime: DateFormat.jm().format(DateTime.now()).toString(),
        endTime: DateFormat.jm().format(DateTime.now().add(Duration(hours:2))).toString(),
        color: Colors.teal,
        priority: 0,
        // remind:
        // repeat:
        category: 'Super Personal',
      ),
    ];



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
              child: ListView.builder(
                itemCount: tasks.length+1,
                  itemBuilder: (context,index){
                return TaskCard(task: index==tasks.length ? null : tasks[index],);
              },
              ),
            )

            // _showTasks()
          ],
        ),
      ),
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
          child: Text(DateFormat.yMMMd().format(context.watch<SelectedDateProvider>().selectedDate),
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
