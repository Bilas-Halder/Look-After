import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Chat/showSharedTaskChat.dart';
import 'package:look_after/DB/chatDB.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:random_string/random_string.dart';

import '../boxes.dart';

class ChatScreen extends StatefulWidget {
  static String path = '/chatScreen';
  final UserModel chatWith;
  ChatScreen(this.chatWith);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserModel user;
  String chatRoomId, messageId = "";
  Stream messageStream;
  String myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();
  String lastMassageSendBy = null, currentMessageSendBy = null;

  getMyInfoFromHive() async {
    user = dbHelper.getCurrentUser();
    myName=user.name;
    myProfilePic = user.imgURL;
    myUserName = user.imgURL;
    myEmail = user.email;
    chatRoomId = getChatRoomIdByUsernames(user.email, widget.chatWith.email);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.compareTo(b) == 1) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      var lastMessageTs = DateTime.now();
      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": user.email,
        "ts": lastMessageTs,
        "isTask" : false,
        "messageId" : messageId,
      };

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEditingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, bool flag, String messageId, bool isTask) {

    return Row(
      mainAxisAlignment:
      sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                !sendByMe ? widget.chatWith?.imgURL != null?
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatWith.imgURL),
                  radius: 16,
                ):
                CircleAvatar(
                  backgroundColor: Colors.teal[700],
                  radius: 16,
                  child: Center(
                    child: Text(
                      widget.chatWith?.name != null ? widget.chatWith?.name[0].toUpperCase() :"C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ):SizedBox(),
                isTask == true ?  ShowSharedTaskChat(messageId: messageId, sendByMe: sendByMe,):
                Container(
                    constraints: BoxConstraints(
                      minWidth: 70,
                      maxWidth: MediaQuery.of(context).size.width*0.7,
                    ),
                    margin: EdgeInsets.only(left: sendByMe? 16 : 10, right: sendByMe ? 10 : 16,  bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: !sendByMe ? Radius.circular(12) : Radius.circular(15),
                        bottomRight:
                        sendByMe ? Radius.circular(0) : Radius.circular(15),
                        topRight: sendByMe ? Radius.circular(12) : Radius.circular(15),
                        bottomLeft:
                        sendByMe ? Radius.circular(15) : Radius.circular(0),
                      ),
                      color: sendByMe ? Colors.teal : Colors.teal.withOpacity(0.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                    child: Flexible(
                      child: Text(
                        message,
                        style: TextStyle(color: sendByMe ? Colors.white : Colors.black),
                      ),
                    )),

                sendByMe ? user?.imgURL != null?
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imgURL),
                  radius: 16,
                ):
                CircleAvatar(
                  backgroundColor: Colors.teal[700],
                  radius: 16,
                  child: Center(
                    child: Text(
                      user?.name != null ? user?.name[0].toUpperCase() :"C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
          )
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 70, top: 16),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              Widget msgWidget;

                msgWidget = chatMessageTile(
                    ds["message"], user.email == ds["sendBy"], lastMassageSendBy == ds["sendBy"], ds['messageId'], ds['isTask']);
                lastMassageSendBy = ds["sendBy"];

              return msgWidget;
            })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromHive();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatWith.name),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTextEditingController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "type a message",
                              hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                        )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}