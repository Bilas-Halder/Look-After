import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/EmaiilAwarenees/emailFormDialog.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/providers/EmailEnabledProvider.dart';
import 'package:provider/src/provider.dart';

import '../profile_screen.dart';

AppBar buildAppbar(BuildContext context, {bool fromHome, String title}) {
  UserModel user = dbHelper.getCurrentUser();
  String t = fromHome==true ? 'Hi, ' : '';

  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        Container(
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
        SizedBox(
          width: 15,
        ),
        Text(
          t+'${user?.name != null ?user?.name?.split(' ')[0]:'Mr.'}!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
    actions: [
      AppbarPopupMenu(),
    ],
  );
}



class AppbarPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (selectedValue){
        if(selectedValue==1){
          context.read<AuthenticationService>().signOut(context);
        }
        else if(selectedValue==0){
          Navigator.of(context).pushNamed(ProfileScreen.path);
        }
        else if(selectedValue==2){
          bool x =context.read<EmailEnabledProvider>().isEmailAwarenessEnabled;
          if(x){
            context.read<EmailEnabledProvider>().setisEmailAwarenessEnabled(!x);
          }
          else{
            showDialog(context: context, useRootNavigator: false, builder: (_) => EmailPassWordFormDialog());
          }

          print(x);
        }
      },
      itemBuilder: (context) {
        bool x=context.read<EmailEnabledProvider>().isEmailAwarenessEnabled;
        return [
          PopupMenuItem(
            value: 0,
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 15,),
                Icon(
                  Icons.manage_accounts_outlined,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 7,),
                Text(
                  'Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19
                  ),
                ),
                SizedBox(width: 7,),
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 15,),
                Icon(
                  x ? Icons.unpublished_outlined : Icons.email_outlined,
                  size: 22,
                  color: Colors.black,
                ),
                SizedBox(width: 7,),
                Text(
                  x ? 'Disable Email' : 'Enable Email',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19
                  ),
                ),
                SizedBox(width: 8,),
              ],
            ),
          ),
          PopupMenuItem(
            value: 1,
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 15,),
                Icon(
                  Icons.logout,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 7,),
                Text(
                  'Log Out',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19
                  ),
                ),
                SizedBox(width: 7,),
              ],
            ),
          ),
        ];
      },

      padding: EdgeInsets.all(0),
      child: Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
        size: 30,
      ),
      iconSize: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft : Radius.circular(10.0),
          bottomLeft : Radius.circular(10.0),
          bottomRight : Radius.circular(10.0),
        ),
      ),
      offset: Offset(-30, 30),
    );
  }
}
