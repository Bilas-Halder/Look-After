import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/DB/chatDB.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:provider/src/provider.dart';

class ProfileScreen extends StatefulWidget {
  //const ({Key? key}) : super(key: key);
  static const path = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phone = "", name = "";
  UserModel user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = dbHelper.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      child: user?.imgURL == null
                          ? Center(
                              child: Text(
                                user?.name==null?'P':user?.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 56,
                                ),
                              ),
                            )
                          : null,
                      decoration: BoxDecoration(
                        color: Colors.teal[700],
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: user?.imgURL != null
                            ? DecorationImage(
                                image: NetworkImage(user.imgURL),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              color: Colors.teal),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Full Name", user?.name, false, "name"),
              buildTextField("Email", user?.email, true, "email"),
              buildTextField("Phone Number", user?.phone, false, "phone"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 14, letterSpacing: 2.2, color: Colors.blue),
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      var newUser = await dbHelper.updateUserToFirebase(user);
                      setState(() {
                        user = newUser;
                      });
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeHolder, bool readOnly, String field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: TextField(
        onChanged: (String value) {
          if(value!='' && value !=null){
            if (field == "phone") {
              user?.phone = value;
            } else if (field == "name") {
              user?.name = value;
            }
          }
        },
        readOnly: readOnly,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeHolder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500])),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            dbHelper.getCurrentUserFromFirebase();
          },
          child: CircleAvatar(
            backgroundImage: AssetImage("images/hridoy.png"),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
