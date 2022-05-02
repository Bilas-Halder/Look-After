import 'package:flutter/cupertino.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/PostModel.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/utilities/navDrawer.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import 'event_room.dart';

class PostEditor extends StatefulWidget {
  static final path = "postEditor_screen";
  final String eventId;
  PostEditor({this.eventId});

  @override
  State<PostEditor> createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  UserModel user = dbHelper.getCurrentUser();
  EventsModel event = new EventsModel();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    // TODO: implement initState
    event = dbHelper.getEventByEventId(eventId: widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(context, from: PostEditor.path),
      appBar: buildAppbar(context,
          myScaffoldKey: _scaffoldKey, title: "Write a Post", fromEvent: true),
      drawerEnableOpenDragGesture: true,
      body: Container(
          child: Column(
        children: [
          QuillToolbar.basic(
            controller: _controller,
            /// multiRowsDisplay: true,
            multiRowsDisplay : false,
            showAlignmentButtons: true,


            showInlineCode : false,
            showBackgroundColorButton : false,
            showClearFormat : false,
            showCodeBlock : false,

            showImageButton : false,
            showVideoButton : false,
            showCameraButton : false,

          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 16),
              child:
                  QuillEditor.basic(controller: _controller, readOnly: false),
            ),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 16, right: 18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () async {

                      String text = _controller.document.toPlainText();
                      var json = _controller.document.toDelta().toJson();
                      if(text!=null && text!=""){
                        try{
                          var post =  PostModel(
                              description: text,
                              jsonDescription: json,
                              datePublished: DateTime.now(),
                              postID: Uuid().v1(),
                              eventID: widget.eventId,
                              profImg: user.imgURL,
                              uid: user.userID,
                              userName: user.name
                          );

                          await dbHelper.addPostToFirebase( post);
                          await dbHelper.addPostIdToFirebase( post);

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EventRoomScreen(event: event)));
                        }
                        catch(e){}
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: postBtnText,
                    )),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
