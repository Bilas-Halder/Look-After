import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:look_after/providers/SelectedDateProvider.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:provider/provider.dart';

import 'NewMailProvider.dart';
import 'TaskCountProvider.dart';


class OurProvider extends StatelessWidget {

  final Widget child;
  OurProvider({this.child});

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
          ),

          ChangeNotifierProvider(create: (_) => TaskProvider()),
          ChangeNotifierProvider(create: (_) => SelectedDateProvider()),
          ChangeNotifierProvider(create: (_) => TasksCountProvider()),
        ],
        child: child
    );;
  }
}
