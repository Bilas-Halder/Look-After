import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final hintText;
  final String type;
  final Function (String) onChanged;
  final bool error;
  final IconData icon;
  InputTextField({this.hintText,this.onChanged, this.type, this.error,this.icon});

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool passVisible=false;
  String inputText='';
  @override
  Widget build(BuildContext context) {

    String type = this.widget.type!=null ? this.widget.type : '';
    type=type.toLowerCase();
    Color color = widget.error ? Color(0xffd60e00) : Colors.teal;
    const atTheRateIcon = Icons.alternate_email_rounded;
    const passIcon = Icons.vpn_key;
    final icon = type=='email'? atTheRateIcon : type=='password'? passIcon : widget.icon;
    double borderWidth = widget.error ? 1.0 : 0;

    Widget getVisibilityIcon(){
      return GestureDetector(
        child: Icon(
          !passVisible
              ? Icons.visibility
              : Icons.visibility_off,
          color: Colors.grey,
        ),
        onTap: (){
          setState(() {
            passVisible=!passVisible;
          });
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(32.0))
      ),
      child: TextField(
        keyboardType: type=='email'? TextInputType.emailAddress: TextInputType.text,
        obscureText: type=='password' && !passVisible,
        onChanged: (value){
          setState(() {
            inputText=value;
          });
          if(widget.onChanged!=null){
            widget.onChanged(value);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(icon,color: Colors.grey,),
          suffixIcon: type=='password' && inputText.length!=0? getVisibilityIcon() : null,
          contentPadding:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: borderWidth),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
      ),
    );
  }
}