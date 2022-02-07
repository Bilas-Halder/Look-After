import 'package:flutter/material.dart';

AppBar buildAppbar(){
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        Container(
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
        size: 35,
      ),
      SizedBox(width: 5,)
    ],
  );
}