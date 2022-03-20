import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/screens/createRoom_screen/room_post.dart';
import 'package:look_after/screens/createRoom_screen/write_post.dart';
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

  @override
  void dispose(){
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roomScreenAppbar(),
      body: Column(
        children: [
          WritePost(eventId : widget.event.eventID),
          RoomPost(eventId : widget.event.eventID)
        ],
      ),
    );
  }
}
