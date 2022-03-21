import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/screens/createRoom_screen/appbar_room.dart';
import 'package:look_after/screens/createRoom_screen/event_screen.dart';
import 'package:look_after/screens/createRoom_screen/show_create_room_dialog.dart';
import 'package:look_after/screens/createRoom_screen/show_join_roomDialog.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/screens/tasks_screen/shareDialog.dart';
import 'package:look_after/utilities/navDrawer.dart';

import '../../utilities/input_field.dart';

class CreateRoomHomeScreen extends StatelessWidget {
  static const String path = '/create_room_home';
  //const ({Key? key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavigationDrawer(context, from: CreateRoomHomeScreen.path),
        appBar: buildAppbar(context, myScaffoldKey: _scaffoldKey),
        drawerEnableOpenDragGesture: true,
        bottomNavigationBar: BottomNavBar(from: CreateRoomHomeScreen.path,),
        body: Container(
          child: Column(
            children: [
              RoomScreen()
            ],
          ),
        ));
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
