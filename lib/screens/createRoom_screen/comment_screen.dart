import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/createRoom_screen/comment_card.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/utilities/navDrawer.dart';

class CommentScreen extends StatefulWidget {
  //const CommentScreen({Key? key}) : super(key: key);
  static const String path = "/comment_screen";
  final String postId;
  final String eventId;
  CommentScreen({this.postId, this.eventId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();

  UserModel user = dbHelper.getCurrentUser();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(context, from: CommentScreen.path),
      appBar: buildAppbar(context,
          myScaffoldKey: _scaffoldKey, title: "Comments", fromEvent: true),
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.imgURL),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "comment as ${user.name}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: () async{
                    try{
                      await dbHelper.postCommentToFirebase(
                          widget.eventId,
                          widget.postId,
                          _commentController.text,
                          user.userID,
                          user.name,
                          user.imgURL);

                      _commentController.clear();
                    }
                    catch(e){}
                  },
                  child: Text("Comment")),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('event_details')
            .doc(widget.eventId)
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  CommentCard(snap: snapshot.data.docs[index]));
        },
      ),
    );
  }
}
