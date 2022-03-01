import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/tasks.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/boxes.dart';
import 'package:look_after/controllers/task_controller.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/input_field.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class EditTaskPage extends StatefulWidget {
  static const String path = '/edit_task';
  final TaskModel task;
  EditTaskPage({this.task});
  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {


  TextEditingController _titleController;
  TextEditingController _noteController;

  DateTime _selectedDate = DateTime.now();
  String _endTime =
  DateFormat("hh:mm a").format(DateTime.now().add(Duration(hours: 1)));
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20, 30, 60];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  Color _selectedColor = Color(Colors.teal.value);
  Color _pickerColor;

  List<String> priorityList = ['High', 'Medium', 'Low'];
  List<String> categoryList = ['Personal', 'Work', 'Health'];
  List<int> colorsList = [
    Colors.teal.value,
    Colors.blue.value,
    Colors.orange.value,
    Colors.redAccent.value,
    Colors.pink.value,
    Colors.pink.value,
  ];
  int _selectedPriority = 0;
  int _selectedCategory = 0;

  @override
  void initState() {
    // TODO: implement initState
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);

    _selectedDate = widget.task.date;
    _selectedPriority= widget.task.priority;
    _selectedCategory= categoryList.indexOf(widget.task.category);
    _selectedColor = Color(widget.task.color);
    _selectedRemind = widget.task.remind;
    _selectedRepeat = widget.task.repeat;


    _startTime = widget.task.startTime;
    _endTime = widget.task.endTime;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit The Task',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                MyInputField(
                  initialString: widget.task.title,
                  title: "Title",
                  hint: "Enter Your Title",
                  controller: _titleController,
                ),
                MyInputField(
                  title: "Note",
                  hint: "Enter Your Note",
                  controller: _noteController,
                ),
                MyInputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                          title: "Start Time",
                          hint: _startTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(true);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                    SizedBox(width: 12),
                    Expanded(
                        child: MyInputField(
                          title: "End Time",
                          hint: _endTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(false);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Category",
                        hint: categoryList[_selectedCategory],
                        widget: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 30,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (int newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                              categoryList.length, (int index) {
                            return DropdownMenuItem(
                              value: index,
                              child: Text(categoryList[index]),
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyInputField(
                        title: "Priority",
                        hint: '${priorityList[_selectedPriority]} Priority',
                        widget: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 30,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (int newValue) {
                            setState(() {
                              _selectedPriority = newValue;
                            });
                          },
                          items: List<DropdownMenuItem<int>>.generate(
                              priorityList.length, (int index) {
                            return DropdownMenuItem(
                              value: index,
                              child: Text(priorityList[index]),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: "Remindeer",
                  hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue);
                      });
                    },
                    items:
                    remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "Repeat",
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedRepeat = newValue;
                      });
                    },
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                        Text(value, style: TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPallete(),
                    AddTask(
                      label: "Save",
                      onTap: () {
                        if(_validate()) {
                          widget.task.title= _titleController.text;
                          widget.task.note= _noteController.text;
                          widget.task.date= _selectedDate;
                          widget.task.startTime= _startTime;
                          widget.task.endTime= _endTime;
                          widget.task.remind= _selectedRemind;
                          widget.task.repeat= _selectedRepeat;
                          widget.task.color= _selectedColor.value;
                          widget.task.priority= _selectedPriority;

                          widget.task.save();
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///adding taskModel to hive database
  void addTaskModelToHiveDB(TaskModel task) {
    final box = Boxes.getTaskModel();
    box.add(task);
    print(box.keys);
    print(box.values);
  }

  bool _validate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // _addTaskToDb();
      NotifyHelper().displayNotification(
          title: "Your Task Has been Added", body: _noteController.text);
      // Get.back();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('All Fields are Required.'));
      Get.snackbar("Required", "All Fields are Required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pink,
          icon: Icon(Icons.warning_amber_rounded));
    }
    return false;
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          children: List<Widget>.generate(6, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if(index == 5){
                    _colorPickerDialog(context);
                  }
                  else{
                    _selectedColor = Color(colorsList[index]);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey, spreadRadius: 0)],
                  ),
                  child: CircleAvatar(
                    child: index == 5 ? Container()
                        : _selectedColor == Color(colorsList[index])
                        ? Icon(
                      Icons.done,
                      color: isBrightColor(_selectedColor)? Colors.black : Colors.white,
                      size: 16,
                    )
                        : Container(),
                    radius: 14,
                    backgroundColor: Color(colorsList[index]),
                    backgroundImage: index == 5 ? AssetImage('images/ColorPicker.png') : null,
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  void _colorPickerDialog(BuildContext context) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() => _pickerColor = color);
              },
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Pick it'),
              onPressed: () {
                setState(() {
                  colorsList.insert(0, _pickerColor.value);
                  _selectedColor = _pickerColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );



  _getDateFromUser() async {
    DateTime _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2115));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {}
  }

  _getTimeFromUser(bool isStartTime) async {
    var _pickedTime = await _showTimePicker(isStartTime);
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker(bool isStartTime) {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay(
        hour: isStartTime ? int.parse(_startTime.split(":")[0]) : int.parse(_endTime.split(":")[0]),
        minute: isStartTime ? int.parse(_startTime.split(":")[1].split(" ")[0]) : int.parse(_endTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

// _addTaskToDb() async{
//   Task ts = Task(
//     note: _noteController.text,
//     title: _titleController.text,
//     date: DateFormat.yMd().format(_selectedDate),
//     startTime: _startTime,
//     endTime: _endTime,
//     remind: _selectedRemind,
//     repeat: _selectedRepeat,
//     color: _selectedColor,
//     isCompleted: 0,
//   );
//
//   int value = await TaskProvider().addTask(
//       task: ts
//   );
//
//   print("My id is: " + "$value");
// }
}
SnackBar showSnackBar(String text){
  return SnackBar(
    backgroundColor: Colors.white,
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.redAccent,
        ),
        SizedBox(width: 5,),
        Text(
          text,
          style: TextStyle(
              color: Colors.redAccent
          ),
        )
      ],
    ),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      textColor: Colors.teal,
      label: 'Got it',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}