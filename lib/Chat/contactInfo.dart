import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Models/userModel.dart';
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
  var userInfo;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState(){
    super.initState();
    getAllContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  /*
  void getUserInfo(String num){
    final _firestoreInstance = FirebaseFirestore.instance;
    _firestoreInstance.collection("user_details").where('phone', isEqualTo: num).get().then((QuerySnapshot val){
      if(val.docs.isNotEmpty){
        Map<String, dynamic> user = {
          'name' : val.docs[0]['name'],
          'email' : val.docs[0]['email'],
          'phone' : val.docs[0]['phone'],
        };
        userFriend.add(UserModel.fromJson(user));
      }
    });
  }

   */

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

      // final _firestoreInstance = FirebaseFirestore.instance;
      // final _collection = _firestoreInstance.collection("user_details");
      // for(int i=0; i<_contacts.length; i++){
      //   String phoneNum;
      //   try{
      //     if(_contacts[i].phones.elementAt(0).number[0]=='+'){
      //       int len = _contacts[i].phones.elementAt(0).number.length;
      //       phoneNum = _contacts[i].phones.elementAt(0).number.substring(3,len);
      //     }else{
      //       phoneNum = _contacts[i].phones.elementAt(0).number;
      //     }
      //
      //     _collection.where('phone', isEqualTo: phoneNum).get().then((QuerySnapshot val){
      //       if(val.docs.isNotEmpty){
      //         Map<String, dynamic> user = {
      //           'name' : val.docs[0]['name'],
      //           'email' : val.docs[0]['email'],
      //           'phone' : val.docs[0]['phone'],
      //         };
      //
      //         _userFriend.add(UserModel.fromJson(user));
      //       }
      //
      //     });
      //   }catch (e){
      //     print("*************There was an Error*********");
      //     print(e);
      //   }
      // }


      setState(() {
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
      floatingActionButton: floatingAddButton(context),
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