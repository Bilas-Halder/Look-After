import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {


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
            blurRadius: 10
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.withOpacity(0.5),

          items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_rounded,size: 30,)
          ),
          BottomNavigationBarItem(
            label: 'Person',
            icon: Icon(Icons.person_rounded,size: 30,)
          ),
        ],),
      ),
    );
  }
}
