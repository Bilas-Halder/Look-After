import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:look_after/screens/profile_screen/cropImage.dart';
import 'package:look_after/utilities/navDrawer.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  //const ({Key? key}) : super(key: key);
  static const path = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phone = "", name = "";
  UserModel user;
  File _image = null;
  bool isImgPicked = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = dbHelper.getCurrentUser();
  }


  Future getImage() async{
    try{
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        _image =  await cropSquareImage(file);
        if(_image!=null){
          setState(() {
            isImgPicked = true;
            print(_image.path);
          });
        }
      }
      else return;
    }
    catch(e){ }
  }

  Future<String> uploadPic() async{
    if(_image==null) return null;

    var user = await dbHelper.getCurrentUser();
    String fileName = await basename(_image.path);
    print('file name => $fileName');
    FirebaseStorage storage = await FirebaseStorage.instance;
    Reference ref = await storage.ref().child("user/profile/${user.email}/${user.email}.jpg");
    await ref.putFile(_image);
    String url = await ref.getDownloadURL();
    print('url ------- $url');
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(context),
      appBar: buildAppbar(context,myScaffoldKey: _scaffoldKey),
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
                    Hero(
                      tag:'profile-img',
                      child: Container(
                        width: 130,
                        height: 130,
                        child: !isImgPicked && user?.imgURL == null
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
                          image: user?.imgURL != null || isImgPicked
                              ? DecorationImage(
                                  image: isImgPicked? FileImage(File(_image.path))  : NetworkImage(user.imgURL),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => getImage(),
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
                      final url = isImgPicked?await uploadPic() : null;
                      if(url!=null){
                        user.imgURL = url;
                      }
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
}
