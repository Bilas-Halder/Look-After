import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:look_after/screens/OnBoarding_screen.dart';
import 'package:look_after/screens/home_screen/home_screen.dart';
import 'package:look_after/screens/tasks_screen/tasks_screen.dart';
import 'package:look_after/screens/welcome_screen.dart';
import 'package:look_after/screens/login_screen.dart';
import 'package:look_after/screens/registration_screen.dart';
import 'package:look_after/screens/chat_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.removeAfter(initialization);

  runApp(LookAfter());
}
void initialization (BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 500));
}

class LookAfter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: OnBoardingPage.path,
        routes: {
          OnBoardingPage.path: (context) => OnBoardingPage(),
          WelcomeScreen.path: (context) => WelcomeScreen(),
          LoginScreen.path: (context) => LoginScreen(),
          RegistrationScreen.path: (context) => RegistrationScreen(),
          ChatScreen.path: (context) => ChatScreen(),
          HomeScreen.path:(context) => HomeScreen(),
          // TasksScreen.path:(context) => TasksScreen()
        },
      ),
    );
  }
}
