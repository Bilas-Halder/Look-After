import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import '../../Models/hive_task_model.dart';
import '../../boxes.dart';
import '../../utilities/input_field.dart';

class showJoinRoomDialog extends StatelessWidget {
  //const showCreateRoomDialog({Key? key}) : super(key: key);

  final TextEditingController _RoomCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 600,
                  padding: EdgeInsets.all(10),
                  child: Center(
                      child: ListView(
                        children: [
                          MyInputField(
                            title: "Room Code",
                            controller: _RoomCode,
                          ),
                          ElevatedButton(
                              onPressed: ()async{
                                await dbHelper.handleJoinEventRoom(_RoomCode.text);
                              },
                              child: Text("Join")
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
    );
  }
}
