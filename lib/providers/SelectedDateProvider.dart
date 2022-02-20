
import 'package:flutter/material.dart';

class SelectedDateProvider with ChangeNotifier{
  DateTime _selectedDate=DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setNewSelectedDate (DateTime date){
    _selectedDate = date;
    notifyListeners();
  }
  void setCurrentDate (){
    _selectedDate = DateTime.now();
    notifyListeners();
  }

}