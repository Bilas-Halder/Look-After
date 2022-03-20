import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/screens/createRoom_screen/appbar_room.dart';
import 'package:look_after/screens/createRoom_screen/event_screen.dart';
import 'package:look_after/screens/createRoom_screen/show_create_room_dialog.dart';
import 'package:look_after/screens/createRoom_screen/show_join_roomDialog.dart';
import 'package:look_after/screens/tasks_screen/shareDialog.dart';

import '../../utilities/input_field.dart';

class CreateRoomHomeScreen  extends StatelessWidget {
  static const String path = '/create_room_home';
  //const ({Key? key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: roomScreenAppbar(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            useRootNavigator: false,
                            builder: (context) => showCreateRoomDialog()
                        );
                      },
                      child: Text(
                        "Create"
                      )
                  ),
                  ElevatedButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            useRootNavigator: false,
                            builder: (context) => showJoinRoomDialog()
                        );
                      },
                      child: Text(
                        "Join"
                      )
                  )
                ],
              ),
            ),
            RoomScreen()
          ],
        ),
      )
    );
  }
}

/*
SnackBar showRoomOption(){
  return SnackBar(
    backgroundColor: Colors.white,
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
            onPressed: (){
              print("Hello It is Pressed");
             showCreateRoomDialog();
            },
            child: Text(
                "Create a Room",
              style: TextStyle(
                color: Colors.black
              ),
            )
        ),
        SizedBox(width: 5),
        TextButton(
            onPressed: (){

            },
            child: Text(
                "Join a Room",
              style: TextStyle(
                  color: Colors.black
              ),
            )
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

 */
