import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/screens/createRoom_screen/post_card.dart';

class RoomPost extends StatelessWidget {
  //const RoomPost({Key? key}) : super(key: key);
  final String eventId;
  RoomPost({this.eventId});

  getPostIds()async {
    QuerySnapshot querySnapshot = await dbHelper.getPostsIds(eventId: eventId);
    Map <String, dynamic> x = querySnapshot.docs[0].data();

  }

  @override
  Widget build(BuildContext context) {

    return  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('event_details').doc(eventId).collection('postsID').orderBy('postingTime', descending: true).snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)
    {


      return FutureBuilder(
          future: dbHelper.getPostsIds(eventId: eventId),
          builder:(context, AsyncSnapshot snapshot) {

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {

              QuerySnapshot  qSnap = snapshot.data;
              final docs = qSnap.docs;
              int count = docs.length;


              return Expanded(
                  child: ListView.builder(

                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: count,

                      itemBuilder: (BuildContext context, int index) {
                        Map<String,dynamic> m = docs[index].data();
                        String postID = m["postID"];

                        dbHelper.fetchPost(eventId: eventId, postID: postID);
                        return PostCard(postID: postID,eventId: eventId,snap: ' ',);
                      }
                  )
              );
            }
          }
      );

    });


    // return  StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection('event_details').doc(eventId).collection('posts').orderBy('datePublished', descending: true).snapshots(),
    //     builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)
    //     {
    //       print('something changed');
    //
    //       if(snapshot.connectionState == ConnectionState.waiting){
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       return Expanded(
    //         child: RefreshIndicator(
    //           onRefresh: ()async{
    //             await sleep(Duration(seconds: 5));
    //           },
    //           child: ListView.builder(
    //
    //             physics: BouncingScrollPhysics(),
    //             shrinkWrap: true,
    //             itemCount: snapshot.data.docs.length,
    //             itemBuilder: (ctx, index){
    //               print('something changed in snapshot');
    //               print(snapshot.data.docs[index].data());
    //               return  Container(
    //                 child: PostCard(
    //                     snap: snapshot.data.docs[index].data(),
    //                     eventId : eventId
    //                 ),
    //               );
    //           },
    //           ),
    //         ),
    //       );
    //     }
    // );
  }
}
