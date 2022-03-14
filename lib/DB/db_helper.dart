import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:intl/intl.dart';
import 'package:look_after/Models/userModel.dart';
import 'package:look_after/providers/SelectedDateProvider.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/hive_task_model.dart';
import '../Models/tasks.dart';
import '../Services/notification_services.dart';
import '../boxes.dart';
import 'dart:isolate';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  NotifyHelper().displayNotification(title: "Hello", body: "Fel Amar");

  String currentTime = DateTime.now().toString().split(' ')[1];
  int hour = int.parse(currentTime.split(':')[0]);
  int minute = int.parse(currentTime.split(':')[1])+1;

  print("*********Setting Alrm*********");
  print(hour);
  print(minute);

  //FlutterAlarmClock.createAlarm(hour, minute);

  //FlutterAlarmClock.createTimer(5);

}
class dbHelper{

  static final _firestoreInstance = FirebaseFirestore.instance;
  static Database _db;
  static final int _version = 1;
  static final String _tableName = "tasks";


  static Future<void> initDb()async{
    if(_db!=null){
      return;
    }

    try{
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version){
          print("Creating a new One");
          return db.execute(
            "Create Table $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, startTime STRING, endTime String, "
                "color INTEGER, "
                "isCompleted INTEGER, remind INTEGER, repeat STRING)",
          );
        },
      );
    }catch(e){
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    await initDb();
    return await _db?.insert(_tableName, task.toJson()??1);
  }

  static Future<List<Map<String, dynamic>>> query() async{
    print("query Functioned Called");
    return await _db.query(_tableName);
  }

  static delete(Task task) async{
    return await _db.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async{
    return await _db.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id =?
    ''', [1, id]);
  }


  ///Firebase Starts Here
  ///adding taskModel to hive database

  static Future addUserToFirebase(UserModel user) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;
    user.userID = currentUser.uid;
    user.verified = currentUser.emailVerified;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users");
    var box = await Boxes.getUserModel();
    await box.clear();
    await box.add(user);
    return _collectionRef.doc(currentUser?.uid).set(
        user.toJson()
    ).then((value) => print("user added :)"));
  }

  static UserModel getCurrentUser(){
    var b = Boxes.getUserModel().values;
    var user;
    for(var i in b){
      user = i;
    }
    return user;
  }
  static bool getIsNewUser(){
    var b = Boxes.getIsNewBox().values;

    if(b.length>0)return false;

    return true;
  }

  static Future <UserModel> getCurrentUserFromFirebase()async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  userID  = _auth.currentUser?.uid;
    DocumentSnapshot  doc = await FirebaseFirestore.instance.collection("users").doc(userID).get();

    try{
      Map<String,dynamic> map = {
        'userID' : doc['userID'],
        'name' : doc['name'],
        'email' : doc['email'],
        'phone' : doc['phone'],
        'imgURL' : doc['imgURL'],
        'username' : doc['username'],
        'verified' : doc['verified'],
        'edited' : doc['edited'],
      };
      UserModel user = await UserModel.fromJson(map);
      var box = await Boxes.getUserModel();
      await box.clear();
      await box.add(user);
      return user ;
    }
    catch(e){
      return null;
    }
  }

  static Future <UserModel> getUserByUserID(String userID)async{
    DocumentSnapshot  doc = await FirebaseFirestore.instance.collection("users").doc(userID).get();

    try{
      Map<String,dynamic> map = {
        'userID' : doc['userID'],
        'name' : doc['name'],
        'email' : doc['email'],
        'phone' : doc['phone'],
        'imgURL' : doc['imgURL'],
        'username' : doc['username'],
        'verified' : doc['verified'],
        'edited' : doc['edited'],
      };

      return await UserModel.fromJson(map);
    }
    catch(e){
      return null;
    }
  }

  static Future <UserModel> updateUserToFirebase(UserModel user) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;
    user.userID = currentUser.uid;
    user.verified = currentUser.emailVerified;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users");

    await _collectionRef.doc(currentUser?.uid).update(
        user.toJson()
    ).then((value) => print("user updated :)"));

    return getCurrentUserFromFirebase();
  }

  static void addTaskModelToHiveDB(TaskModel task) async {

    await addTaskToFirebase(task);

    //Set Alarm for the task
    // handleScheduleNotifications(task);
    //Setting Alarm
    //FlutterAlarmClock.createAlarm(hour, minute);
    final box = Boxes.getTaskModel();
    box.add(task);

  }

  static DateTime convertTime (DateTime taskDate, String startTime){
    String s = DateFormat('yyyyMMdd').format(taskDate);
    s+='T' ;
    String t1 = startTime.split(':')[0];
    String t2 = startTime.split(':')[1].split(' ')[0];
    s+=(t1.length==2 ? t1 : '0$t1');
    s+=(t2.length==2 ? t2 : '0$t2');
    DateTime newDate = DateTime.parse(s);

    print("************Printing Date Format*************");
    return newDate;
  }

  static void handleScheduleNotifications(TaskModel task)async{

    final int helloAlarmID = 0;
    DateTime taskDate = convertTime(task.date, task.startTime);
    print("************Printing Date Format*************");
    print(taskDate);
    await AndroidAlarmManager.oneShotAt(taskDate, helloAlarmID, printHello, exact: true);
  }

  static Future addTaskToFirebase(TaskModel task){
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;

    String taskId = currentUser.email+task.time_stamp.toString();
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("task_details");
    return _collectionRef.doc(currentUser?.email).collection("personal").doc(taskId).set(
        task.toJson()
    ).then((value) => print("Hello"));
  }

  static Future<void> updateToFirebase(TaskModel task){
    print("**************Update Firebase****************");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;

    String taskId = currentUser.email+task.time_stamp.toString();
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("task_details");
    return _collectionRef.doc(currentUser?.email).collection("personal").doc(taskId).update(
        task.toJson()
    ).then((value) => print("Hello"));
  }

  static Future<void> deleteFromFirebase(TaskModel task){
    print("**************Delete Firebase****************");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;

    String taskId = currentUser.email+task.time_stamp.toString();
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("task_details");
    return _collectionRef.doc(currentUser?.email).collection("personal").doc(taskId).delete().then((value) => print("Hello"));
  }

  static void fetchTasksFromFirebase()async{

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;
    QuerySnapshot qn = await _firestoreInstance.collection("task_details").doc(currentUser?.email).collection("personal").get();

    print(qn.docs.length);
    for(int i=0; i<qn.docs.length; i++){

      Map<String, dynamic> ts = {
        'email' : qn.docs[i]['email'],
        'title' : qn.docs[i]['title'],
        'note' : qn.docs[i]['note'],
        'status' : qn.docs[i]['status'],
        'date' : qn.docs[i]['date'].toDate(),
        'startTime' : qn.docs[i]['startTime'],
        'endTime' : qn.docs[i]['endTime'],
        'remind' : qn.docs[i]['remind'],
        'repeat' : qn.docs[i]['repeat'],
        'priority' : qn.docs[i]['priority'],
        'category' : qn.docs[i]['category'],
        'color' : qn.docs[i]['color'],
        'time_stamp' : qn.docs[i]['time_stamp'].toDate(),
      };
      addAllTaskModelToHiveDB(TaskModel.fromJson(ts));
    }
  }

  ///adding taskModel to hive database
  static void addAllTaskModelToHiveDB(TaskModel task) {
    //Set Alarm for the task
    // print(task);
    // DateTime date = DateFormat.jm().parse(task.startTime.toString());
    // var myTime = DateFormat("HH:mm").format(date);
    // int hour = int.parse(myTime.toString().split(":")[0]);
    // int minute = int.parse(myTime.toString().split(":")[1]);
    // FlutterAlarmClock.createAlarm(hour, minute);
    final box = Boxes.getTaskModel();
    box.add(task);

  }


}
