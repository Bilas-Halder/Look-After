import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/screens/createRoom_screen/room_post.dart';
import 'package:look_after/screens/createRoom_screen/write_post.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/utilities/navDrawer.dart';
import '../../Models/hive_task_model.dart';
import 'appbar_room.dart';

class EventRoomScreen extends StatefulWidget {
  //const EventRoomScreen({Key? key}) : super(key: key);
  static const String path = "/event_room_page";
  final EventModel event;
  EventRoomScreen({this.event});
  @override
  _EventRoomScreenState createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  UserModel user = dbHelper.getCurrentUser();
  final TextEditingController _descriptionController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose(){
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context,fromEvent : true, event: widget.event, myScaffoldKey: _scaffoldKey),
      key: _scaffoldKey,
      drawer: NavigationDrawer(context, from: EventRoomScreen.path),
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: BottomNavBar(from: EventRoomScreen.path,),
      body: Column(
        children: [
          WritePost(eventId : widget.event.eventID),
          RoomPost(eventId : widget.event.eventID)
        ],
      ),
    );
  }
}
