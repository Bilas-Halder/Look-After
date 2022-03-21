
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Models/hive_task_model.dart';

class EventPopupMenu extends StatelessWidget {
  final EventModel event;
  EventPopupMenu({this.event});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selectedValue){
        if(selectedValue==2){

        }
        if(selectedValue==1){
        }
        else if(selectedValue==0){

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
              SizedBox(width: 5,),
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
              SizedBox(width: 5,),
              Text('Add Member')
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.grey[500],
                size: 24,
              ),
              SizedBox(width: 5,),
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
          topLeft : Radius.circular(10.0),
          bottomLeft : Radius.circular(10.0),
          bottomRight : Radius.circular(10.0),
        ),
      ),
      offset: Offset(-16, 10),
    );
  }
}