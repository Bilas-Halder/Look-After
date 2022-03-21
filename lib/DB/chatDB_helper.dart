import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';

import '../boxes.dart';

class ChatHelper{
  static final _firestoreInstance = FirebaseFirestore.instance;

  static UserModel user = dbHelper.getCurrentUser();

  static createChatRoom(UserModel currentUser, UserModel anotherUser) async {
    String chatRoomId = await getChatRoomId(currentUser.email, anotherUser.email);

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

  static Future<Stream<QuerySnapshot>> getChatRooms() async {
    return await FirebaseFirestore.instance
        .collection("chat_rooms")
        .where("usersId", arrayContains: user.userID)
        .snapshots();
  }

  static Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  static Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  static shareTask(String chatRoomId,UserModel currentUser, UserModel shareToUser, Map messageInfoMap, TaskModel task)async{

    await addMessage(chatRoomId, messageInfoMap['messageId'], messageInfoMap);
    var _collectionRef = FirebaseFirestore.instance.collection("shared_tasks").doc(messageInfoMap['messageId']);
    await _collectionRef.set(
        {
          'from':currentUser.email,
          'to' : shareToUser.email,
          'ts' : messageInfoMap['ts'],
          'id' : messageInfoMap['messageId']
        });
    await _collectionRef.collection("task").doc('1x1').set(
        task.toJson()
    ).then((value) => print("Task shared completely"));
  }

  static updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }


  static getSharedTask(String messageId) async{

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestoreInstance.collection("shared_tasks").doc(messageId).collection("task").doc('1x1').get();

    print('-----------------------');
    print(doc['email']);
    print(doc['title']);
    print(doc['note']);
    print('-----------------------');

      Map<String, dynamic> task = await {
        'email' : doc['email'],
        'title' : doc['title'],
        'note' : doc['note'],
        'status' : doc['status'],
        'date' : doc['date'].toDate(),
        'startTime' : doc['startTime'],
        'endTime' : doc['endTime'],
        'remind' : doc['remind'],
        'repeat' : doc['repeat'],
        'priority' : doc['priority'],
        'category' : doc['category'],
        'color' : doc['color'],
        'time_stamp' : doc['time_stamp'].toDate(),
      };
      return await TaskModel.fromJson(task);
    }

  static getChatRoomId(String a, String b) {
    if (a.compareTo(b) == 1) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

}