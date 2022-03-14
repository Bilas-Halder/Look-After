import 'package:flutter/material.dart';
import 'package:look_after/Chat/getContacts.dart';
import 'package:look_after/DB/chatDB.dart';
import 'package:look_after/DB/chatDB_helper.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:random_string/random_string.dart';

import 'add_task.dart';

class ShareDialog extends StatefulWidget {
  final TaskModel task;
  ShareDialog({this.task});

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  List<UserModel> friends = null;
  int selected = null;

  @override
  void initState() {
    // TODO: implement initState
    getFriends();
    super.initState();
  }

  getFriends() async {
    friends = await getAllFriendsInfo();
    await setState(() {});
    print(friends);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TaskCategoryDesign(
                  task: 'Share With',
                ),
                friends == null || friends?.length == 0
                    ? Container(
                        height: 200,
                        child: Center(
                          child: Text(
                            'There is no friend \nusing our service',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 200,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: friends?.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (selected == index) {
                                        setState(() {
                                          selected = null;
                                        });
                                      } else {
                                        setState(() {
                                          selected = index;
                                        });
                                      }
                                    },
                                    child: FriendsCard(
                                      friend: friends[index],
                                      selected: selected == index,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 20, bottom: 0),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.teal,
                        title: 'Cancel',
                        width: 90,
                        reversed: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      friends == null || friends?.length == 0
                          ? CustomButton(
                              onPressed: () {
                                Flushbar(
                                  leftBarIndicatorColor: Colors.teal,
                                  icon: Icon(
                                    Icons.sentiment_very_satisfied_rounded,
                                    color: Colors.red[200],
                                    size: 30,
                                  ),
                                  title: 'Work in progress.',
                                  message:
                                      'We are working so please wait some time.',
                                  duration: Duration(seconds: 2),
                                ).show(context);
                              },
                              color: Colors.teal,
                              title: 'Invite',
                              width: 100,
                            )
                          : CustomButton(
                              onPressed: () async {
                                if (selected == null) {
                                  Flushbar(
                                    leftBarIndicatorColor: Colors.teal,
                                    icon: Icon(
                                      Icons.update_rounded,
                                      color: Colors.teal[100],
                                      size: 30,
                                    ),
                                    title:
                                        'Please Select a friend to share the task.',
                                    message:
                                        'if you can\'t find the desired friend please invite.',
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                  return;
                                }
                                var user = await dbHelper.getCurrentUser();

                                await shareTask(
                                    user, friends[selected], widget.task);
                                Navigator.pop(context);

                                Flushbar(
                                  leftBarIndicatorColor: Colors.teal,
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.teal[200],
                                    size: 30,
                                  ),
                                  title: 'Task is Shared.',
                                  message:
                                  'Task is Shared with ${friends[selected].name}.',
                                  duration: Duration(seconds: 3),
                                ).show(context);
                              },
                              color: Colors.teal,
                              title: 'Share',
                              width: 100,
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendsCard extends StatelessWidget {
  final UserModel friend;
  final bool selected;
  FriendsCard({this.friend, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: selected ? Colors.teal.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(friend.name),
        subtitle: Text(
          friend.phone,
        ),
        leading: friend?.imgURL != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(friend.imgURL),
              )
            : CircleAvatar(
                backgroundColor: Colors.teal[700],
                child: Center(
                  child: Text(
                    friend?.name != null ? friend?.name[0].toUpperCase() : "C",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class TaskCategoryDesign extends StatelessWidget {
  final String task;
  TaskCategoryDesign({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Stack(
        children: [
          Container(
            height: 35,
            color: Colors.teal,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  height: 26,
                  child: Center(
                    child: Text(
                      '${task}.',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

shareTask(UserModel cUser, UserModel sUser, TaskModel task) async {
  var messageId = await randomAlphaNumeric(12);
  var lastMessageTs = await DateTime.now();
  var chatRoomId = await ChatHelper.getChatRoomId(cUser.email, sUser.email);

  Map<String, dynamic> messageInfoMap = await {
    "message": 'This a Shared task',
    "sendBy": cUser.email,
    "ts": lastMessageTs,
    "isTask": true,
    "messageId": messageId,
  };

  await ChatHelper.shareTask(chatRoomId, cUser, sUser, messageInfoMap, task)
      .then((value) {
    Map<String, dynamic> lastMessageInfoMap = {
      "lastMessage": 'A task is Shared',
      "lastMessageTs": lastMessageTs,
      "lastMessageSendBy": sUser.email
    };
    DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
  });
  await ChatHelper.getSharedTask(messageId);
}
