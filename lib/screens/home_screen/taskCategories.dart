import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/taskCategory.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:look_after/screens/tasks_screen/tasks_screen.dart';

import '../../boxes.dart';
import 'add_&_edit_category.dart';

class TaskCategories extends StatefulWidget {
  @override
  State<TaskCategories> createState() => _TaskCategoriesState();
}

class _TaskCategoriesState extends State<TaskCategories> {
  final taskList = TaskCategory.generateTasks();

  @override
  void initState() {
    final taskCategories =
        Boxes.getTaskCategoryModel().values.toList().cast<TaskCategoryModel>();
    if (taskCategories.isEmpty) {
      List<TaskCategoryModel> categories =
          TaskCategoryModel.generateDefaultTaskCategories();
      int i = 0;
      for (var category in categories) {
        addTaskCategoryModelToHiveDB(category);
        print('Added ${i++}');
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<TaskCategoryModel>>(
      valueListenable: Boxes.getTaskCategoryModel().listenable(),
      builder: (context, box, _) {
        final taskCategories = box.values.toList().cast<TaskCategoryModel>();

        return Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: taskCategories.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => index == taskCategories.length
                ? buildAddTask()
                : BuildTaskCategory(taskCategories[index], index),
          ),
        );
      },
    );
  }

  Widget buildAddTask() {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, useRootNavigator: false, builder: (_) => ShowAddCategoryDialog());
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(20),
        dashPattern: [10, 10],
        color: Colors.grey,
        strokeWidth: 2,
        child: Center(
          child: Text(
            '+ Add',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


class BuildTaskCategory extends StatelessWidget {
  final TaskCategoryModel category;
  final int index;
  BuildTaskCategory(this.category, this.index);
  @override
  Widget build(BuildContext context) {
    Icon icon = category.deleteAble ? Icon(
      Icons.trip_origin,
      color: Color(category.color),

      ///Icon color
      size: 35,
    ):
    Icon(
      // IconData(category.icon, fontFamily: 'MaterialIcons'),
      //TODO make change here for dynamic icons and build with --no-tree-shake-icons command
      Icons.trip_origin,
        color: Color(category.color),

    ///Icon color
    size: 35,
    );

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TasksScreen(taskCategory: category, fromDone: false, fromLeft: false,)));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color(category.color).withOpacity(0.25),

            ///background color
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon
                ,
                CategoryPopupMenu(category: category,index:index)
              ],
            ),
            Hero(
              tag: 'tasks${category.title}',
              child: Container(
                child: Text(
                  category.title == 'All' ? 'All Tasks' : category.title,
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
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => TasksScreen(taskCategory: category, fromDone: false, fromLeft: true,)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Color(category.color).withOpacity(0.35),

                          ///btn color
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        'Left',
                        style: TextStyle(color: Colors.black),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => TasksScreen(taskCategory: category, fromDone: true, fromLeft: false,)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        'Done',
                        style: TextStyle(color: Colors.black),
                      )),
                    ),
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


class CategoryPopupMenu extends StatelessWidget {
  final TaskCategoryModel category;
  final int index;
  CategoryPopupMenu({this.category, this.index});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selectedValue){
        if(selectedValue==1 ){
          if(category.deleteAble){
            category.delete();
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(showSnackBar('You can\'t delete default categories.'));
          }
        }
        else if(selectedValue==0){
          showDialog(context: context, useRootNavigator: false, builder: (_) => ShowEditCategoryDialog(category: category,));
        }
      },
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
      child: Container(
        padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 10.0),
        child: Icon(
          Icons.more_vert_outlined,
          color: Colors.black,
          size: 24,
        ),
      ),
      iconSize: 24,
      offset: index%2==0? Offset(30,20) : Offset(-20,20),

      shape: index%2!=0?  RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft : Radius.circular(10.0),
          bottomLeft : Radius.circular(10.0),
          bottomRight : Radius.circular(10.0),
        ),
      ) : RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight : Radius.circular(10.0),
          bottomLeft : Radius.circular(10.0),
          bottomRight : Radius.circular(10.0),
        ),
      ) ,
    );
  }
}


///adding taskModel to hive database
void addTaskCategoryModelToHiveDB(TaskCategoryModel taskCategory) {
  final box = Boxes.getTaskCategoryModel();
  box.add(taskCategory);
  print(box.keys);
  print(box.values);
}