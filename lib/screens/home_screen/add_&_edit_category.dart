import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/screens/home_screen/taskCategories.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/input_field.dart';

import '../../boxes.dart';
import '../../constants.dart';

class ShowAddCategoryDialog extends StatefulWidget {
  final TaskCategoryModel category;
  final bool editing;
  ShowAddCategoryDialog({this.category, this.editing});

  @override
  State<ShowAddCategoryDialog> createState() => _ShowAddCategoryDialogState();
}

class _ShowAddCategoryDialogState extends State<ShowAddCategoryDialog> {
  TextEditingController _titleController;

  Color _selectedColor;
  Color _pickerColor;
  String previousTitle;
  bool isTitleEmpty = false;
  bool isUnique = true;

  TaskCategoryModel category;
  bool editing;

  final List<int> colorsList = [
    Colors.teal.value,
    Colors.blue.value,
    Colors.orange.value,
    Colors.redAccent.value,
    Colors.pink.value,
    Colors.pink.value,
  ];
  @override
  void initState() {
    // TODO: implement initState
    editing = widget.editing ?? false;
    category = editing ? widget.category : null;

    _titleController = editing
        ? TextEditingController(text: category.title)
        : TextEditingController();
    _selectedColor = editing ? Color(category.color) : Color(Colors.teal.value);
    previousTitle = editing ? category.title : '';

    if (editing) {
      if (colorsList.indexOf(category.color) == -1) {
        colorsList.insert(0, category.color);
        colorsList.removeAt(colorsList.length - 2);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            width: width + 100,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      editing
                          ? 'Make changes to ${category.title}.'
                          : 'Add a new Category.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  MyInputField(
                    title: "Title",
                    hint: "Enter Your Title",
                    controller: _titleController,
                    readOnly: editing && !category.deleteAble?1:0,
                  ),
                  isTitleEmpty
                      ? SizedBox(
                          height: 8,
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  isTitleEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Title is required for Category.',
                              style: TextStyle(color: Colors.redAccent),
                            )
                          ],
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  !isUnique && !isTitleEmpty
                      ? SizedBox(
                          height: 8,
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  !isUnique && !isTitleEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Similar Titled Category Exist.',
                              style: TextStyle(color: Colors.redAccent),
                            )
                          ],
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  _colorPalette(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AddTaskButton(
                        onTap: () {
                          if (_titleController.text != null &&
                              _titleController.text != '') {
                            isTitleEmpty = false;
                            isUnique = true;

                            var taskCategories = Boxes.getTaskCategoryModel()
                                .values
                                .toList()
                                .cast<TaskCategoryModel>();

                            for (var c in taskCategories) {
                              if (!editing &&
                                  c.title.toLowerCase() ==
                                      _titleController.text.toLowerCase()) {
                                isUnique = false;
                              } else if (editing &&
                                  c.title.toLowerCase() ==
                                      _titleController.text.toLowerCase() &&
                                  previousTitle.toLowerCase() !=
                                      _titleController.text.toLowerCase()) {
                                isUnique = false;
                              }
                            }
                            setState(() {});
                          } else {
                            setState(() {
                              isTitleEmpty = true;
                            });
                          }

                          if (!editing) {
                            if (isUnique && !isTitleEmpty) {
                              addTaskCategoryModelToHiveDB(TaskCategoryModel(
                                  title: _titleController.text,
                                  color: _selectedColor.value,
                                  deleteAble: true));
                              NotifyHelper().displayNotification(
                                  title: "A new Task Category Has been Added",
                                  body:
                                      'New category name is ${_titleController.text}.');
                              Navigator.pop(context);
                            }
                          }
                          else if (isUnique  && !isTitleEmpty) {
                            category.title = _titleController.text;
                            category.color = _selectedColor.value;

                            category.save();
                            NotifyHelper().displayNotification(
                              title:
                                  "Some changes in ${previousTitle} Category has been made.",
                            );
                            Navigator.pop(context);
                          }
                        },
                        label: editing ? 'Save' : 'Create',
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _colorPalette() {
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
                  if (index == 5) {
                    _colorPickerDialog(context);
                  } else {
                    _selectedColor = Color(colorsList[index]);
                    print(Color(colorsList[index]));
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3, color: Colors.grey, spreadRadius: 0)
                    ],
                  ),
                  child: CircleAvatar(
                    child: index == 5
                        ? Container()
                        : _selectedColor.value == colorsList[index]
                            ? Icon(
                                Icons.done,
                                color: isBrightColor(_selectedColor)
                                    ? Colors.black
                                    : Colors.white,
                                size: 16,
                              )
                            : Container(),
                    radius: 14,
                    backgroundColor: Color(colorsList[index]),
                    backgroundImage: index == 5
                        ? AssetImage('images/ColorPicker.png')
                        : null,
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  void _colorPickerDialog(BuildContext context) => showDialog(
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
                  if (_pickerColor != null) {
                    if (colorsList.indexOf(_pickerColor.value) == -1) {
                      colorsList.insert(0, _pickerColor.value);
                      colorsList.removeAt(colorsList.length - 2);
                      _selectedColor = _pickerColor;
                      _pickerColor = null;
                    } else {
                      _selectedColor = _pickerColor;
                      _pickerColor = null;
                    }
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}

class ShowEditCategoryDialog extends StatefulWidget {
  final TaskCategoryModel category;
  ShowEditCategoryDialog({this.category});

  @override
  _ShowEditCategoryDialogState createState() => _ShowEditCategoryDialogState();
}

class _ShowEditCategoryDialogState extends State<ShowEditCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    return ShowAddCategoryDialog(
      category: widget.category,
      editing: true,
    );
  }
}
