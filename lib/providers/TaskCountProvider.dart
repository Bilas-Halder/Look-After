import 'package:flutter/material.dart';

class TasksCountProvider with ChangeNotifier{
  int _tasksLeft=0;
  int _tasksDone=0;

  int get tasksLeft => _tasksLeft;
  int get tasksDone => _tasksDone;

  void setTaskCounts (int tasksLeft , int tasksDone){
    _tasksLeft = tasksLeft;
    _tasksDone = tasksDone;
    notifyListeners();
  }

  void setTasksLeft (int tasksLeft){
    _tasksLeft = tasksLeft;
    notifyListeners();
  }
  void setLeftZero (){
    _tasksLeft = 0;
    notifyListeners();
  }

  void setTasksDone (int tasksDone){
    _tasksDone = tasksDone;
    notifyListeners();
  }
  void setDoneZero (){
    _tasksDone = 0;
    notifyListeners();
  }

}