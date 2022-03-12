
import 'package:flutter/material.dart';
import 'package:look_after/Chat/getContacts.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/screens/home_screen/taskCategories.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/screens/home_screen/goPremium.dart';
import 'package:look_after/utilities/buttons.dart';

class RoomScreen extends StatefulWidget {
  static const String path = '/room_screen';

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoPremium(),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            child: Text(
              'Tasks',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: TaskCategories(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  floatingAddButton(context),
    );
  }
}
