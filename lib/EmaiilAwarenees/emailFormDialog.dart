import 'package:flutter/material.dart';
import 'package:look_after/EmaiilAwarenees/loginToEmail.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/input_field.dart';

class EmailPassWordFormDialog extends StatefulWidget {

  @override
  State<EmailPassWordFormDialog> createState() => _EmailPassWordFormDialogState();
}

class _EmailPassWordFormDialogState extends State<EmailPassWordFormDialog> {
  final TextEditingController _emailController =  TextEditingController();

  final TextEditingController _passwordController =  TextEditingController();

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            width: width + 100,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Enable Email Awareness',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  MyInputField(
                    title: "Email",
                    hint: "Enter Your Email",
                    controller: _emailController,
                  ),
                  MyInputField(
                    title: "Password",
                    hint: "Enter Your Password",
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: checkedValue,
                          onChanged: (bool value) {
                            setState(() {
                              checkedValue = value;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Accepting the ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14
                        ),
                      ),
                      Text(
                        'terms and conditions',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 14,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AddTaskButton(
                        label: 'Enable',
                        onTap: !checkedValue ? null : ()async{
                         await loginToMail(_emailController.text, _passwordController.text,context);
                         print('Mail connection successful');
                         },
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
