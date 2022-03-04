import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/providers/Provider.dart';
import 'package:look_after/screens/OnBoarding_screen.dart';
import 'package:look_after/screens/home_screen/home_screen.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:look_after/screens/welcome_screen.dart';
import 'package:look_after/screens/login_screen.dart';
import 'package:look_after/screens/registration_screen.dart';
import 'package:look_after/screens/chat_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Models/hive_task_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.removeAfter(initialization);

  var notifyHelper;
  notifyHelper = NotifyHelper();
  notifyHelper.initializeNotification();
  notifyHelper.requestIOSPermissions();

  /// hive database
  await Hive.initFlutter();
  
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('taskModels');
  Hive.registerAdapter(TaskCategoryModelAdapter());
  await Hive.openBox<TaskCategoryModel>('taskCategoryModels');

  runApp(LookAfter());
}

void initialization(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 500));
}

class LookAfter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OurProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: OnBoardingPage.path,
        routes: {
          OnBoardingPage.path: (context) => OnBoardingPage(),
          WelcomeScreen.path: (context) => WelcomeScreen(),
          LoginScreen.path: (context) => LoginScreen(),
          RegistrationScreen.path: (context) => RegistrationScreen(),
          ChatScreen.path: (context) => ChatScreen(),
          HomeScreen.path: (context) => HomeScreen(),
          AddTaskPage.path: (context) => AddTaskPage(),
// TasksScreen.path:(context) => TasksScreen()
        },
      ),
    );
  }
}
