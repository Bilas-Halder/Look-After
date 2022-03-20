import 'package:flutter/material.dart';
import 'package:look_after/Chat/chatRoom.dart';
import 'package:look_after/screens/home_screen/home_screen.dart';

class BottomNavBar extends StatelessWidget {
  final String from;
  BottomNavBar({this.from});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10)
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.grey.withOpacity(0.5),
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          onTap: (int index) {
            var routeName = ModalRoute.of(context)?.settings?.name;

            if (index == 1 && routeName!=ChatRooms.path) {
              // Navigator.pushNamed(context, ContactScreen.path);
              Navigator.pushNamed(context, ChatRooms.path);
            } else if (index == 0 && routeName!=HomeScreen.path) {
              Navigator.pushNamed(context, HomeScreen.path);
            }
          },
          items: [
            BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(
                  Icons.home_rounded,
                  size: 30,
                  color: from==HomeScreen.path? Colors.teal : Colors.grey.withOpacity(0.5),
                )),
            BottomNavigationBarItem(
                label: 'Chat Room',
                icon: Icon(
                  Icons.question_answer_rounded,
                  size: 30,
                  color: from==ChatRooms.path? Colors.teal : Colors.grey.withOpacity(0.5),
                )),
          ],
        ),
      ),
    );
  }
}
