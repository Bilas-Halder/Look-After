import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/Chat/chatRoom.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/EmailAwareness/emailFormDialog.dart';
import 'package:look_after/providers/EmailEnabledProvider.dart';
import 'package:look_after/screens/createRoom_screen/create_room_home.dart';
import 'package:look_after/screens/home_screen/home_screen.dart';
import 'package:look_after/screens/profile_screen/profile_screen.dart';
import 'package:provider/src/provider.dart';

import 'package:flutter_icons/flutter_icons.dart';

Drawer NavigationDrawer(BuildContext context, {String from}) {
  final user = dbHelper.getCurrentUser();
  bool isEmailEnable =
      context.watch<EmailEnabledProvider>().isEmailAwarenessEnabled;
  const navTextColor = Colors.white;
  const navIconColor = Colors.white;

  var routeName = ModalRoute.of(context)?.settings?.name;

  return Drawer(
    backgroundColor: Colors.teal[700],
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Hero(
                tag: 'profile-img',
                child: Container(
                  width: 130,
                  height: 130,
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
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.white,
        ),
        ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () {
            Navigator.pop(context);
            if(routeName !=HomeScreen.path){
              NavigateOnTap(context, HomeScreen.path);
            }
          },
          leading: Icon(
            Icons.home,
            size: 26,
          ),
          title: Text(
            'Home',
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () {
            Navigator.pop(context);
            if(routeName !=ChatRooms.path){
              NavigateOnTap(context, ChatRooms.path);
            }
          },          leading: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              Icons.chat,
              size: 22,
            ),
          ),
          title: Text(
            'Chat Room',
            style: TextStyle(fontSize: 18),
          ),
        ),
        ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () {
            Navigator.pop(context);
            if(routeName !=ProfileScreen.path){
              NavigateOnTap(context, ProfileScreen.path);
            }
          },          leading: Icon(
            Icons.person_rounded,
            size: 26,
          ),
          title: Text(
            'User Profile',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.white,
        ),
        from!=ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async {
            if (isEmailEnable) {
              Navigator.pop(context);
              context
                  .read<EmailEnabledProvider>()
                  .setisEmailAwarenessEnabled(!isEmailEnable);

              await Flushbar(
                leftBarIndicatorColor: Colors.teal,
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.red[200],
                  size: 30,
                ),
                title: 'Email Awareness Disabled.',
                message: 'Your email awareness is disabled.',
                duration: Duration(seconds: 2),
              ).show(context);
            } else {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) => EmailPassWordFormDialog());
            }
          },
          leading: Icon(
            isEmailEnable ? Icons.unsubscribe_rounded : Icons.email_rounded,
            size: 24,
          ),
          title: Text(
            isEmailEnable ? 'Disable Email' : 'Enable Email',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),
        from!=ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async {
            if (isEmailEnable) {
              Navigator.pop(context);
              context
                  .read<EmailEnabledProvider>()
                  .setisEmailAwarenessEnabled(!isEmailEnable);

              await Flushbar(
                leftBarIndicatorColor: Colors.teal,
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.red[200],
                  size: 30,
                ),
                title: 'Email Awareness Disabled.',
                message: 'Your email awareness is disabled.',
                duration: Duration(seconds: 2),
              ).show(context);
            } else {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) => EmailPassWordFormDialog());
            }
          },
          leading: Icon(
            isEmailEnable ? Icons.unsubscribe_rounded : Icons.email_rounded,
            size: 24,
          ),
          title: Text(
            isEmailEnable ? 'Disable Email' : 'Enable Email',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),
        from!=ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async {
            if (isEmailEnable) {
              Navigator.pop(context);
              context
                  .read<EmailEnabledProvider>()
                  .setisEmailAwarenessEnabled(!isEmailEnable);

              await Flushbar(
                leftBarIndicatorColor: Colors.teal,
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.red[200],
                  size: 30,
                ),
                title: 'Email Awareness Disabled.',
                message: 'Your email awareness is disabled.',
                duration: Duration(seconds: 2),
              ).show(context);
            } else {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (_) => EmailPassWordFormDialog());
            }
          },
          leading: Icon(
            isEmailEnable ? Icons.unsubscribe_rounded : Icons.email_rounded,
            size: 24,
          ),
          title: Text(
            isEmailEnable ? 'Disable Email' : 'Enable Email',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),


        from==ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async { },
          leading: Icon(
            AntDesign.wechat,
            size: 24,
          ),
          title: Text(
            'Create Group',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),
        from==ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async { },
          leading: Icon(
            AntDesign.wechat,
            size: 24,
          ),
          title: Text(
            'Create Group',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),
        from==ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async { },
          leading: Icon(
            AntDesign.wechat,
            size: 24,
          ),
          title: Text(
            'Create Group',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),

        from==ChatRooms.path ? ListTile(
          textColor: navTextColor,
          iconColor: navIconColor,
          onTap: () async {
            Navigator.pop(context);
            Navigator.pushNamed(context, CreateRoomHomeScreen.path);
          },
          leading: Icon(
            AntDesign.wechat,
            size: 24,
          ),
          title: Text(
            'Create Group',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          ),
        ) : Container(),


        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                textColor: navTextColor,
                iconColor: navIconColor,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  context.read<AuthenticationService>().signOut(context);
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.logout,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
                ),
                trailing: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 30.0, bottom: 8.0, right: 16),
                    child: Icon(
                      Icons.menu_open,
                      size: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.white,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '2022 \u00a9 Bilas & Hridoy',
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

void NavigateOnTap(BuildContext context, String path) {
  Navigator.pop(context);
  Navigator.pushNamed(context, path);
}
