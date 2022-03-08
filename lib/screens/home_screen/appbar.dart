import 'package:flutter/material.dart';
import 'package:look_after/Authentication/Authentication.dart';
import 'package:provider/src/provider.dart';

AppBar buildAppbar(BuildContext context){
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        GestureDetector(
          onTap: (){
            context.read<AuthenticationService>().signOut();

          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Color(0xff020248),
                borderRadius: BorderRadius.circular(12.0)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset('images/userImg.png'),
            ),
          ),
        ),
        SizedBox(width: 15,),
        Text('Hi, Bilas!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
    actions: [
      Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
        size: 30,
      ),
      SizedBox(width: 5,)
    ],
  );
}