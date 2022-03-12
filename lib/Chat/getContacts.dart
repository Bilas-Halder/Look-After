import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';

Future <List<UserModel>> getAllFriendsInfo() async{
  List<UserModel> _userFriend = [];
  var currentUser = dbHelper.getCurrentUser();

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

        await _collection.where('phone', isEqualTo: phoneNum).get().then((QuerySnapshot val){

          if(val.docs.isNotEmpty){
            print('-------------------');
            print(val.docs[0]['email']);
            print(val.docs[0]['phone']);
            print('-------------------');

            if(currentUser.email != val.docs[0]['email']){
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

              _userFriend.add(UserModel.fromJson(map));
            }
          }

        });
      }catch (e){
        print("*************There was an Error in contact*********");
        print(e);
      }
    }
  }
  return _userFriend;
}