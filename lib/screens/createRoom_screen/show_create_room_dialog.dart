import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';

import '../../utilities/input_field.dart';

class showCreateRoomDialog extends StatelessWidget {
  //const showCreateRoomDialog({Key? key}) : super(key: key);

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.all(0),
      content: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;

          return Container(
            width: width -100,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(

                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 175,
                          width: 600,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                              child: ListView(
                                children: [
                                  MyInputField(
                                    title: "Room Name",
                                    controller: _titleController,
                                  ),
                                  SizedBox(height: 10,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                    ),


                                      onPressed: (){
                                      Navigator.pop(context);
                                        dbHelper.addEventModelToHiveDB(
                                            EventModel(
                                              name: _titleController.text,
                                            )
                                        );
                                      },
                                      child: Text("Create")
                                  )
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
