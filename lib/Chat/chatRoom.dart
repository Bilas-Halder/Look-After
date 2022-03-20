import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Chat/chat_screen.dart';
import 'package:look_after/DB/chatDB_helper.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/navDrawer.dart';

class ChatRooms extends StatefulWidget {
  static String path = '/chatRooms';
  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  UserModel chatUser;
  Stream chatRooms;
  TextEditingController searchController = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var user = dbHelper.getCurrentUser();

  @override
  void initState(){
    super.initState();
    getChatRooms();
  }

  getChatRooms()async{
    chatRooms = await ChatHelper.getChatRooms();
    await setState(() { });
  }


  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppbar(context, myScaffoldKey: _scaffoldKey),
      drawer: NavigationDrawer(context,from: ChatRooms.path,),
      bottomNavigationBar: BottomNavBar(from: ChatRooms.path,),
      floatingActionButton: floatingAddButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                // controller: searchUsernameEditingController,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: "username"),
                              )),
                          GestureDetector(
                            // onTap: () {
                            //   if (searchUsernameEditingController.text != "") {
                            //     onSearchBtnClick();
                            //   }
                            // },
                              child: Icon(Icons.search))
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: chatRooms,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                String userID = user.userID != ds['usersId'][0] ? ds['usersId'][0] : ds['usersId'][1];

                                return ChatTile(chatroom: ds, userID: userID,);
                              })
                              : Center(child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatefulWidget {
  final DocumentSnapshot chatroom;
  final String userID;
  ChatTile({this.chatroom, this.userID});

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  DocumentSnapshot chatroom;
  UserModel chatUser= UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatroom = widget.chatroom;
    setChatUse(widget.userID);
  }


  setChatUse(String userID)async{
    chatUser = await dbHelper.getUserByUserID(userID);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(chatUser)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)
        ),
        child: ListTile(
          title: Text(
            chatUser?.name??"",
            style: TextStyle(
                fontSize: 19,
              fontWeight: FontWeight.w600
            ),),
          subtitle: Text(
            chatroom['lastMessage']??"",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          leading: chatUser?.imgURL != null?
          CircleAvatar(
            backgroundImage: NetworkImage(chatUser.imgURL),
          ):
          CircleAvatar(
            backgroundColor: Colors.teal[700],
            child: Center(
              child: Text(
                chatUser?.name != null ? chatUser?.name[0].toUpperCase() :"C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }
}
