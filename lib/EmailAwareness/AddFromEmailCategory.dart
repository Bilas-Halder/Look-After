
import 'package:flutter/material.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/home_screen/taskCategories.dart';

import '../boxes.dart';

void addFromEmailCategory(){
  var taskCategories = Boxes.getTaskCategoryModel()
      .values
      .toList()
      .cast<TaskCategoryModel>();
  bool isUnique = true;

  for (var c in taskCategories) {
    if ( c.title.toLowerCase() == 'from email') {
      isUnique = false;
      break;
    }
  }

  if(isUnique){
    addTaskCategoryModelToHiveDB(TaskCategoryModel(
        title: 'From Email',
        color: Colors.red.value,
        deleteAble: false));
  }

}