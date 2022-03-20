import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/createRoom_screen/event_room.dart';

import '../../boxes.dart';

class RoomScreen extends StatefulWidget {
  //const RoomScreen({Key? key}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ValueListenableBuilder<Box<EventModel>>(
          valueListenable: Boxes.getEventModel().listenable(),
          builder: (context, box, _){
            final events= box.values.toList().cast<EventModel>();

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> EventRoomScreen(event: events[index]))
                    );
                  },
                  child: Container(
                    height: 100,
                    color: Colors.teal,
                    child: Center(
                      child: Text(
                        events[index].name
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
    );
  }
}
