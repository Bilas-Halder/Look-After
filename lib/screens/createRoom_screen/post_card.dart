import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/createRoom_screen/comment_screen.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';

class PostCard extends StatefulWidget {
  //const PostCard({Key? key}) : super(key: key);
  final snap;
  String eventId;
  PostCard({this.snap, this.eventId});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  int commentLength = 0;
  UserModel user = dbHelper.getCurrentUser();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async{
    try{
      //QuerySnapshot snap = FirebaseFirestore.instance.collection('event_details').doc(eventID).collection('posts').doc(postID).collection('comments').get();
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('event_details').doc(widget.eventId).collection('posts').doc(widget.snap['postID']).collection('comments').get();

      setState(() {
        commentLength = snap.docs.length;
      });
    }catch(e){
      showSnackBar(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4).copyWith(right: 0),
          ),
          Container(
            child:
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImg']),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['userName'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    )
                ),
                IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context) => Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          children: [
                            (widget.snap['uid'] == user.userID) ? 'delete' : ''
                          ].map((e) => InkWell(
                            onTap: ()async{
                              if(e=='delete'){
                                await dbHelper.deletePostFromFirebase(widget.eventId, widget.snap['postID']);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Text(e),
                            ),
                          )
                          ).toList(),
                        ),
                      )
                      );
                    },
                    icon: Icon(Icons.more_vert)
                )
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Text(
              widget.snap['description']
            ),
          ),

          Row(
            children: [
              IconButton(
                  onPressed: (){

                  },
                  icon: Icon(Icons.create_outlined)
              ),
              IconButton(
                  onPressed: (){
                    print(widget.snap['postID']);
                    //Navigator.pushNamed(context, CommentScreen.path);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentScreen(postId: widget.snap['postID'], eventId: widget.eventId)
                        )
                    );
                  },
                  icon: Icon(Icons.comment_outlined)
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.bookmark_outlined),
                    ),
                  )),
            ],
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all ${commentLength} comments",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}
