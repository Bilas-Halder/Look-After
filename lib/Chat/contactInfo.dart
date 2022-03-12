import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Chat/getContacts.dart';
import 'package:look_after/DB/chatDB_helper.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Chat/chat_screen.dart';
import 'package:look_after/screens/home_screen/bottomNavigationBar.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactScreen extends StatefulWidget {
  static const path = '/contact_screen';
  const ContactScreen({Key key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];
  List<UserModel> friends = [];
  List<Contact> contactsFiltered = [];
  UserModel currentUser;
  var userInfo;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState(){
    super.initState();
    getAllContacts();
    currentUser = dbHelper.getCurrentUser();
    searchController.addListener(() {
      filterContacts();
    });
  }


  void getUserInfo(String num){
    final _firestoreInstance = FirebaseFirestore.instance;
    _firestoreInstance.collection("users").where('phone', isEqualTo: num).get().then((QuerySnapshot val){
      if(val.docs.isNotEmpty){
        var doc = val.docs[0];
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
        friends.add(UserModel.fromJson(map));
      }
    });
  }


  void filterContacts(){
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if(searchController.text.isNotEmpty){
      _contacts.retainWhere((contact){
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();

        bool nameMatches = contactName.contains(searchTerm);
        if(nameMatches){
          return true;
        }
        var phone = contact.phones.firstWhere((phn){
          return phn.number.contains(searchTerm);
        }, orElse: () => null);
        return phone!=null;
      });
    }

    setState(() {
      contactsFiltered = _contacts;
    });
  }

  void getAllContacts() async{
    List<UserModel> _userFriend = [];
    if (await FlutterContacts.requestPermission()){
      List<Contact> _contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      final _firestoreInstance = FirebaseFirestore.instance;
      final _collection = _firestoreInstance.collection("users");
      for(int i=0; i<_contacts.length; i++){
        String phoneNum;
        try{
          if(_contacts[i].phones.elementAt(0).number[0]=='+'){
            int len = _contacts[i].phones.elementAt(0).number.length;
            phoneNum = _contacts[i].phones.elementAt(0).number.substring(3,len);
          }else{
            phoneNum = _contacts[i].phones.elementAt(0).number;
          }

          print(phoneNum);

          await _collection.where('phone', isEqualTo: phoneNum).get().then((QuerySnapshot val){
            if(val.docs.isNotEmpty){
              var doc = val.docs[0];
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

              if(map['phone']!=currentUser.phone){
                _userFriend.add(UserModel.fromJson(map));
              }
            }

          });
        }catch (e){
          print("*************There was an Error*********");
          print(e);
        }
      }


      setState(() {
        friends = _userFriend;
        contacts = _contacts;
        // friends = _userFriend;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      appBar: _appBar(context),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.teal,
        onPressed: ()async {
          print('88888888');
          var friends = await getAllFriendsInfo();
          for( var i in friends){
            print(i.name);
            print(i.email);
            print(i.phone);
          }
          print('88888888');
        },
        child: Icon(Icons.add, size: 30,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.blue
                          )
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      )
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (context, index){
                    var user =friends[index];
                    return GestureDetector(
                      onTap: (){
                        ChatHelper.createChatRoom(currentUser, user);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(user)));
                      },
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text(
                          user.phone,
                        ),
                        leading: user?.imgURL != null?
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.imgURL),
                        ):
                        CircleAvatar(
                          backgroundColor: Colors.teal[700],
                          child: Center(
                            child: Text(
                                user?.name != null ? user?.name[0].toUpperCase() :"C",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),

                      ),
                    );
                  },
                ),
              )
            ],
          )
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/hridoy.png"),
        ),
        SizedBox(width: 10,),
      ],
    );
  }
}


/*
Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (isSearching == true)? contactsFiltered.length : contacts.length,
                  itemBuilder: (context, index){
                    Contact contact = (isSearching == true)? contactsFiltered[index]: contacts[index];
                    return ListTile(
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phones.elementAt(0).number,
                      ),
                      leading: (contact.thumbnail!=null && contact.thumbnail.length>0)?
                      CircleAvatar(
                        backgroundImage: MemoryImage(contact.thumbnail),
                      ):
                      CircleAvatar(
                        child: Text(
                            "C"
                        ),
                      ),

                    );
                  },
                ),
              )
 */