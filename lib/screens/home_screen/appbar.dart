import 'package:flutter/material.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:provider/src/provider.dart';

import '../profile_screen.dart';

AppBar buildAppbar(BuildContext context) {
  UserModel user = dbHelper.getCurrentUser();
  print(user?.imgURL);
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        GestureDetector(
          onTap: () {
            context.read<AuthenticationService>().signOut(context);
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.circular(12.0)),
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
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          'Hi, ${user?.name != null ?user?.name?.split(' ')[0]:'Mr.'}!',
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
        onTap: () {
          Navigator.pushNamed(context, ProfileScreen.path);
        },
        child: Icon(
          Icons.more_vert_outlined,
          color: Colors.black,
          size: 30,
        ),
      ),
      SizedBox(
        width: 5,
      )
    ],
  );
}
