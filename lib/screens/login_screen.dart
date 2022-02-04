import 'package:flutter/cupertino.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/screens/registration_screen.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/errorMessage.dart';
import 'package:look_after/utilities/inputField.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String path = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  bool showSpinner = false;
  bool error = false;
  String errorMsg = "Error Occurred.";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
                      Hero(
                        tag: 'logo',
                        child: Center(
                            child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2, 5),
                                    blurRadius: 10.0),
                              ]),
                        )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                          ErrorMessage(
                            errorMsg: errorMsg,
                            error: error,
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          LogInButton(
                            title: 'Log In',
                            color: Colors.teal[500],
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              if (email == null ||
                                  email == '' ||
                                  password == null ||
                                  password == '') {
                                setState(() {
                                  error = true;
                                  errorMsg = "Email & Password required.";
                                  showSpinner = false;
                                });
                                return;
                              }

                              try {
                                final msg = await context
                                    .read<AuthenticationService>()
                                    .signIn(email: email, password: password);

                                print(msg);
                                if (msg == 'Signed In') {
                                  setState(() {
                                    error = false;
                                  });
                                  Navigator.pushNamed(context, ChatScreen.path);
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
                                'Don\'t have an account?',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RegistrationScreen.path);
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              clipper: CustomClipPath(),
            ),
            GestureDetector(
              child: Container(
                height: screenHeight * 0.22,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text('or',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                      width: screenWidth * 0.70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Image.asset(
                            'images/google-icon.png',
                            height: 28.0,
                          ),
                          Text(
                            ' Sign in with Google',
                            style: TextStyle(
                                color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: (){
                final user = signInWithGoogle();
                print('signInWithGoogle fff');
              },
            )
          ],
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 50, size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
