import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';

import '../boxes.dart';

class ChatHelper{

  static UserModel user = dbHelper.getCurrentUser();

  static createChatRoom(UserModel currentUser, UserModel anotherUser) async {
    String chatRoomId = getChatRoomId(currentUser.email, anotherUser.email);

    Map <String, dynamic> chatRoomInfoMap = {
      'usersId': [currentUser.userID, anotherUser.userID],
      'lastMassage' : null,
      'lastMassageTS' : null,
    };

    final snapShot = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    final hiveBox = Boxes.getUserModel();
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .orderBy("lastMessageTs", descending: true)
        .where("usersId", arrayContains: user.userID)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }


  static getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

}