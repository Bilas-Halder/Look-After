import 'package:flutter/material.dart';
class ErrorMessage extends StatelessWidget {
  final errorMsg;
  final error;
  final double fontSize;
  ErrorMessage({this.errorMsg, this.error, this.fontSize});

  @override
  Widget build(BuildContext context) {
    if(!error)return SizedBox(
      height: 0,
      width: 0,
    );
    return Column(
      children: [

        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Color(0xffBC0C00),
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(
              errorMsg,
              style: TextStyle(
                  color: Color(0xffBC0C00),
                fontSize: fontSize ?? 15,
              ),
            )

          ],
        ),
      ],
    );
  }
}
