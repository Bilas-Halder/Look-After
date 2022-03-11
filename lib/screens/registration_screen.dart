import 'package:firebase_auth/firebase_auth.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/screens/Chat/chat_screen.dart';
import 'package:look_after/screens/login_screen.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/customClipPath.dart';
import 'package:look_after/utilities/errorMessage.dart';
import 'package:look_after/utilities/inputField.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home_screen/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static final String path ='/registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //
  // final _auth = FirebaseAuth.instance;

  String email,password,username,cPass;
  bool showSpinner = false;
  bool error=false;
  String errorMsg = "Error Occurred.";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipPath(
                child: Container(
                  height: screenHeight * 0.78,
                  color: Colors.teal[300],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center         ,
                          children: <Widget>[
                            Hero(
                              tag: 'logo',
                              child: Container(
                                child: Image.asset('images/square-logo.png'),
                                height: 60.0,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      color: Colors.grey,
                                      offset: Offset(2, 5),
                                      blurRadius: 10.0),
                                ],),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InputTextField(
                              hintText: 'Enter your Name',
                              error: error,
                              icon: Icons.person_outline ,
                              onChanged: (String value) {
                                username = value;
                              },
                              type: 'name',
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            InputTextField(
                              hintText: 'Enter your email',
                              error: error,
                              onChanged: (String value) {
                                email = value;
                              },
                              type: 'email',
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            InputTextField(
                              hintText: 'Enter your password',
                              error: error,
                              onChanged: (String value) {
                                password = value;
                              },
                              type: 'password',
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            InputTextField(
                              hintText: 'Confirm your password',
                              error: error,
                              onChanged: (String value) {
                                cPass = value;
                              },
                              type: 'password',
                            ),
                            ErrorMessage(
                              errorMsg: errorMsg,
                              error: error,
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                clipper: CustomClipPath(),
              ),
              Container(
                height: screenHeight * 0.22,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10,),

                      LogInButton(
                        title: 'Register Now',
                        color: Colors.teal[500],
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if (username == null || username == ''){
                            setState(() {
                              error = true;
                              errorMsg = "Username required.";
                              showSpinner = false;
                            });
                            return;
                          }
                          if (email == null || email == '' || password == null || password == '') {
                            setState(() {
                              error = true;
                              errorMsg = "Email & Password required.";
                              showSpinner = false;
                            });
                            return;
                          }

                          if (password != cPass) {
                            setState(() {
                              error = true;
                              errorMsg = "Password mismatched, try password correctly.";
                              showSpinner = false;
                            });
                            return;
                          }

                          try {
                            final msg = await context
                                .read<AuthenticationService>()
                                .signUp(email: email, password: password, name: username);

                            print(msg);
                            if (msg == 'Signed Up') {
                              setState(() {
                                error = false;
                              });
                              Navigator.pushReplacementNamed(context, HomeScreen.path);
                            } else {
                              setState(() {
                                error = true;
                                errorMsg = msg;
                              });
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.path);
                            },
                            child: Text(
                              ' login',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          )
                        ],
                      )
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

