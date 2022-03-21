import 'package:another_flushbar/flushbar.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
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
                                    title: "Room Code",
                                    controller: _RoomCode,
                                  ),
                                  SizedBox(height: 10,),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                      ),


                                      onPressed: () async {

                                        var f =await dbHelper.handleJoinEventRoom(_RoomCode.text);
                                        Navigator.pop(context);
                                          if(f==false){
                                            await Flushbar(
                                              leftBarIndicatorColor: Colors.red,
                                              icon: Icon(
                                                Icons.done,
                                                color: Colors.red[200],
                                                size: 30,
                                              ),
                                              title: 'You are already in this event.',
                                              message:
                                              'You are already joined this event.',
                                              duration: Duration(seconds: 2),
                                            ).show(context);
                                          }
                                      },
                                      child: Text("Join"),
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

//
// MyInputField(
// title: "Room Code",
// controller: _RoomCode,
// ),

