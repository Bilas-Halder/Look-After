import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/screens/createRoom_screen/post_card.dart';

class RoomPost extends StatelessWidget {
  //const RoomPost({Key? key}) : super(key: key);
  final String eventId;
  RoomPost({this.eventId});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('event_details').doc(eventId).collection('posts').orderBy('datePublished', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Expanded(
            child: ListView.builder(

              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (ctx, index) => Container(
                child: PostCard(
                    snap: snapshot.data.docs[index].data(),
                    eventId : eventId
                ),
              ),
            ),
          );
        }
    );
  }
}
