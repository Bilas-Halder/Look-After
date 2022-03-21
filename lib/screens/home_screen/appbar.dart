import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';

AppBar buildAppbar(BuildContext context, {bool fromHome, bool fromEvent, EventModel event, String title, GlobalKey<ScaffoldState> myScaffoldKey}) {
  UserModel user = dbHelper.getCurrentUser();
  String t = fromHome==true ? 'Hi, ' : '';

  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        fromEvent==true ? Container(): Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(-1.0, -1.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          child: user?.imgURL != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(user?.imgURL),
                )
              : Center(
                  child: Text(
                    user?.name != null ? user?.name[0].toUpperCase() : 'P',
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                ),
        ),

        fromEvent==true ?  Container(
          child: Icon(
            Icons.calendar_today_rounded,
            color: Colors.white,
            size: 18,
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.red[900],
              shape: BoxShape.circle),
        ) : Container(),

        SizedBox(
          width: 15,
        ),



        Text(
          title!=null && title!='' ? title : fromEvent==true ? event.name : t+'${user?.name != null ?user?.name?.split(' ')[0]:'Mr.'}!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
    actions: [
      GestureDetector(
        onTap: (){
          myScaffoldKey.currentState.openDrawer();
        },
        child: Icon(
          Icons.menu_rounded,
          color: Colors.black,
          size: 30,
        ),
      ),
      SizedBox(width: 16,),

    ],
  );
}
