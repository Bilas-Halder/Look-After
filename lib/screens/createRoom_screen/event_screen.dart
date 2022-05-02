import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/createRoom_screen/eventPopupMenu.dart';
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
        child: ValueListenableBuilder<Box<EventsModel>>(
      valueListenable: Boxes.getEventsModel().listenable(),
      builder: (context, box, _) {
        final List<EventsModel> events = box.values.toList().cast<EventsModel>();

        if (events.length == 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Join or Create New Events.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          );
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index)  {
            var event = events[index];

            return BuildEventListView(event: event,);
          },
        );

      },
    ));
  }
}

class BuildEventListView extends StatefulWidget {
  final EventsModel event;
  BuildEventListView({this.event});
  @override
  _BuildEventListViewState createState() => _BuildEventListViewState();
}

class _BuildEventListViewState extends State<BuildEventListView> {

  final borderRadius = BorderRadius.circular(15);
  EventsModel event = EventsModel();
  UserModel user = UserModel();
  final double height = 70;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(()async{
      event = await widget.event;
      user = await dbHelper.getUserByUserID(event.ownerID);
      setState(() {});
    });

  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  EventRoomScreen(event: event)));
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.65),
                offset: const Offset(0.0, 0.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.6),
                  borderRadius: borderRadius,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.3),
                          borderRadius: borderRadius,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.red[900],
                                          shape: BoxShape.circle),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 10,),
                                          Text(
                                            event?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                          SizedBox(height: 24,),
                                          Text(
                                            user?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black.withOpacity(0.7),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),

                                    EventPopupMenu(event: event,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: (height/4)+(height/2),)
                  ],
                ),
              ),

              Positioned(
                bottom:( height/2)-(height/4),
                right: 23,
                child: Container(
                  width: height,
                  height: height,
                  child: user?.imgURL == null
                      ? Center(
                    child: Text(
                      user?.name == null
                          ? 'P'
                          : user?.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                      ),
                    ),
                  )
                      : null,
                  decoration: BoxDecoration(
                    color: Colors.teal[700],
                    border: Border.all(
                      width: 4,
                      color: Colors.white,
                    ),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 10))
                    ],
                    shape: BoxShape.circle,
                    image: user?.imgURL != null
                        ? DecorationImage(
                      image: NetworkImage(user.imgURL),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
