import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:look_after/DB/chatDB.dart';
import 'package:look_after/DB/db_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/screens/home_screen/home_screen.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:look_after/screens/welcome_screen.dart';

import '../boxes.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  getCurrentUserID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth?.currentUser?.uid;
  }

  Future<void> signOut(BuildContext context) async {
    await Boxes.getTaskCategoryModel().clear();
    await Boxes.getTaskModel().clear();
    await Boxes.getUserModel().clear();

    await _firebaseAuth.signOut();
    Navigator.pushReplacementNamed(context,WelcomeScreen.path);
  }

  Future<String> signIn({String email, String password}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await dbHelper.getCurrentUserFromFirebase();

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signUp({String email, String password, String name}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      User userDetails = await result.user;
      await dbHelper.addUserToFirebase(UserModel(
          userID: userDetails.uid,
          email: userDetails.email,
          name: name,
          imgURL: userDetails.photoURL,
          phone: null,
          edited: false,
          verified: userDetails.emailVerified,
          username: name.replaceAll(' ', '')));

      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User userDetails = result.user;

    if (result != null) {
      var user = await dbHelper.getCurrentUserFromFirebase();
      if(user?.edited == true){
        Navigator.pushReplacementNamed(context, HomeScreen.path);
        return ;
      }
      user.name = userDetails.displayName;
      user.imgURL= userDetails.photoURL;
      user.verified= userDetails.emailVerified;
      user.username= userDetails.displayName.replaceAll(' ', '');

      if(user!=null){
        await dbHelper.updateUserToFirebase(user);

        Navigator.pushReplacementNamed(context, HomeScreen.path);
        return ;
      }

      await dbHelper.addUserToFirebase(UserModel(
              userID: userDetails.uid,
              email: userDetails.email,
              name: userDetails.displayName,
              imgURL: userDetails.photoURL,
              phone: null,
              edited: false,
              verified: userDetails.emailVerified,
              username: userDetails.displayName.replaceAll(' ', '')))
          .then((value) {
        Navigator.pushReplacementNamed(context, HomeScreen.path);
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(showSnackBar('Something is wrong please try again.'));
    }
  }
}

///for User data =>
//final user = context.watch <User>();
///for signIn =>
//final msg = await context.read <AuthenticationService>().signIn(email: email, password: password);
///for signUp =>
//final msg = await context.read <AuthenticationService>().signUp(email: email, password: password);
///for signOut =>
//context.read<AuthenticationService>().signOut();

/// Use provider to get access of all of those
/*
    MultiProvider(
    providers: [
    Provider<AuthenticationService>(
    create: (_) => AuthenticationService(FirebaseAuth.instance),
    ),
    StreamProvider(
    create: (context) =>
    context.read<AuthenticationService>().authStateChanges,
    initialData: null,
    )
    ],
    child: MaterialApp(),
    );
*/
