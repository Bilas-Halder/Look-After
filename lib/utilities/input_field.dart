import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  //const MyInputField({Key? key}) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController controller;
  final Widget widget;
  const MyInputField({
    this.title,
    this.hint,
    this.controller,
    this.widget
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,

            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget==null?false:true,
                    autofocus: false,
                    cursorColor: Colors.grey[700],
                    controller: controller,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.white
                          )
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.white
                          )
                        ),
                      )
                  ),
                ),
                widget==null?Container():Container(child: widget)
              ],
            ),
          )
        ],
      ),
    );
  }
}
