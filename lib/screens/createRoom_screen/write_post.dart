import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/screens/createRoom_screen/post_editor.dart';
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
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostEditor(eventId: eventId)
            )
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              //Add a text pic, otherwise.
              backgroundImage: NetworkImage(user.imgURL),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "What You Want to Share?",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16
                ),

              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal
              ),
                onPressed: (){},
                child: Text("Post")
            ),
          ],
        ),
      ),
    );
  }
}

