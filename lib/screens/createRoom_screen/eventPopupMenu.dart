import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/tasks_screen/shareDialog.dart';

class EventPopupMenu extends StatelessWidget {
  final EventsModel event;
  EventPopupMenu({this.event});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selectedValue) async {
        if (selectedValue == 0) {
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16).copyWith(right: 7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    width: width + 100,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Room Code :- ${event.eventID}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () async{
                                  Clipboard.setData(ClipboardData(text: event.eventID));
                                  await Flushbar(
                                    leftBarIndicatorColor: Colors.teal,
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.teal[300],
                                      size: 30,
                                    ),
                                    title: 'Room Code is Copied to Clipboard.',
                                    message: 'Share Room Code with your Friends.',
                                    duration: Duration(milliseconds: 1500),
                                  ).show(context);

                                  Navigator.pop(context);
                                  },
                                icon: Icon(
                                  Icons.content_copy,
                                  color: Colors.grey[700],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        else if (selectedValue == 1) {
        }
        else if (selectedValue == 2) {
          var str = await dbHelper.deleteEventFromFirebase(event.eventID, event);

          await Flushbar(
            leftBarIndicatorColor: Colors.teal,
            icon: Icon(
              Icons.check_circle,
              color: Colors.red[300],
              size: 30,
            ),
            title: str,
            message: str,
            duration: Duration(milliseconds: 1500),
          ).show(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.share,
                color: Colors.grey[500],
                size: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Invite')
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.person_add,
                color: Colors.grey[500],
                size: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Add Member')
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.grey[500],
                size: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Delete')
            ],
          ),
        ),
      ],
      padding: EdgeInsets.all(0),
      child: Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
        size: 24,
      ),
      iconSize: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      offset: Offset(-16, 10),
    );
  }
}
