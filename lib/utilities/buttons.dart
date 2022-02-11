import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  final Color color,textColor;
  final String title;
  final Function onPressed;
  LogInButton({this.title,this.color,@required this.onPressed,this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.teal,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.circular(30.0),
        ),

        child: MaterialButton(
          onPressed: onPressed!=null?onPressed:(){},
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color:textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


