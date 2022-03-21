import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:uuid/uuid.dart';

import '../../Models/hive_task_model.dart';

class WritePost extends StatelessWidget {
  final String eventId;
  WritePost({this.eventId});
  //const WritePost({Key? key}) : super(key: key);

  final UserModel user = dbHelper.getCurrentUser();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose(){
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            //Add a text pic, otherwise.
            backgroundImage: NetworkImage(user.imgURL),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: "Write a Post.",
                  border: InputBorder.none
              ),

            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal
            ),
              onPressed: (){
                dbHelper.addPostToFirebase(
                    PostModel(
                        description: _descriptionController.text,
                        datePublished: DateTime.now(),
                        postID: Uuid().v1(),
                        eventID: eventId,
                        profImg: user.imgURL,
                        uid: user.userID,
                        userName: user.name
                    )
                );
              },
              child: Text("Post")
          ),
          Divider()
        ],
      ),
    );
  }
}
