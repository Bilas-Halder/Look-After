import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/PostModel.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/createRoom_screen/RichtextQuillReadOnly.dart';
import 'package:look_after/screens/createRoom_screen/comment_screen.dart';

class PostCard extends StatefulWidget {
  //const PostCard({Key? key}) : super(key: key);
  final postID;
  final snap;
  final String eventId;
  PostCard({this.postID, this.snap, this.eventId});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  UserModel user = dbHelper.getCurrentUser();
  bool reacted = false;

  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("event_details").doc(widget.eventId).collection('posts').doc(widget.postID).snapshots(),
    builder:(context, AsyncSnapshot snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      return FutureBuilder(
        future: dbHelper.fetchPost(eventId: widget.eventId, postID: widget.postID),
        builder: (context, AsyncSnapshot snapshot) {

          if(!snapshot.hasData){
            return Container();
          }

          PostModel post = snapshot.data;

          var dateTime = DateFormat("MMM d, yyyy").format(post?.datePublished) == DateFormat("MMM d, yyyy").format(DateTime.now()) ? DateFormat("hh:mm a ").format(post?.datePublished) : DateFormat("MMM d ").format(post?.datePublished) + 'at ' + DateFormat("hh:mm a").format(post?.datePublished);

          int commentLength = post.totalComments;
          reacted = post.reactors[user.userID]!=null;


          return Container(
            decoration: BoxDecoration(
              // color: Color(0xffc6e5e4),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 1.0), //(x,y)
                    blurRadius: 3.0,
                  ),
                ]
            ),


            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 21,
                        backgroundImage: NetworkImage(post.profImg),
                      ),
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  dateTime,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                      IconButton(
                          onPressed: (){
                            if(post.uid == user.userID){
                              showDialog(context: context, builder: (dialogContext) => Dialog(
                                child: ListView(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  shrinkWrap: true,
                                  children: [
                                    (post.uid == user.userID) ? 'delete' : ''
                                  ].map((e) => InkWell(
                                    onTap: ()async{
                                      if(e=='delete'){
                                        await dbHelper.deletePostFromFirebase(widget.eventId, post.postID);
                                        Navigator.of(dialogContext).pop();
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
                            }

                          },
                          icon: Icon(Icons.more_vert)
                      )
                    ],
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: post.jsonDescription != null ? RichTextQuillReadOnly(jsonDescription: post.jsonDescription,)
                      : SelectableText(
                    post.description,
                  ),
                ),

                SizedBox(height: 15,),

                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Container(
                        child: Text(
                          commentLength==0 && post.totalReacts==0? "Be first to comment" : post.totalReacts!=0 ? "${post.totalReacts} Likes" :"",
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentScreen(post: post,postId: post.postID, eventId: widget.eventId)
                              )
                          );
                        },
                        child: Container(
                          child: Text(
                            commentLength!=0? "${commentLength} comments" : "",
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top : 14, right: 8 , bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap:(){
                                if(reacted){
                                  post.removeReact(user.userID);
                                  setState(() {
                                    reacted = !reacted;
                                  });
                                }
                                else{
                                  post.react("like", user.userID);
                                  setState(() {
                                    reacted = !reacted;
                                  });
                                }

                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.thumb_up_outlined,
                                    size: 21,
                                    color: reacted ?Colors.blueAccent[700] : Colors.blueGrey,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Like",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: reacted ?Colors.blueAccent[700] : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap:(){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CommentScreen(post:post, postId: widget.postID, eventId: widget.eventId)
                                    )
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 21,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    "Comment",
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          );
        },
      );
    }
    );




  }
}


